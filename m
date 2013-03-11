Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36963 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab3CKURb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 16:17:31 -0400
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org, Goffredo Baroncelli <kreijack@gmail.com>,
        Harald Glatt <mail@hachre.de>, Roger Binns <rogerb@rogerbinns.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Diego Calleja <diegocg@gmail.com>, sam tygier <samtygier@yahoo.co.uk>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH v2 1/5] Use NcMsPp format for mkfs
Date: Mon, 11 Mar 2013 20:17:24 +0000
Message-Id: <1363033048-17481-2-git-send-email-hugo@carfax.org.uk>
In-Reply-To: <1363033048-17481-1-git-send-email-hugo@carfax.org.uk>
References: <1363033048-17481-1-git-send-email-hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Teach mkfs.btrfs about ncmspp format for replication levels, which avoids
the semantic uncertainty over the "RAID-XYZ" naming.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 mkfs.c |   91 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 84 insertions(+), 7 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index b2520ce..70df5db 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -326,7 +326,9 @@ static void print_usage(void)
 	fprintf(stderr, "options:\n");
 	fprintf(stderr, "\t -A --alloc-start the offset to start the FS\n");
 	fprintf(stderr, "\t -b --byte-count total number of bytes in the FS\n");
-	fprintf(stderr, "\t -d --data data profile, raid0, raid1, raid5, raid6, raid10, dup or single\n");
+	fprintf(stderr, "\t -d --data data profile: <n>c[d][<m>s[<p>p]]\n");
+	fprintf(stderr, "\t\tfor n copies (d=reduced dev redundancy), m stripes, p parity stripes\n");
+	fprintf(stderr, "\t\tor raid0, raid1, raid10, dup or single (deprecated)\n");
 	fprintf(stderr, "\t -l --leafsize size of btree leaves\n");
 	fprintf(stderr, "\t -L --label set a label\n");
 	fprintf(stderr, "\t -m --metadata metadata profile, values like data profile\n");
@@ -346,8 +348,36 @@ static void print_version(void)
 	exit(0);
 }
 
-static u64 parse_profile(char *s)
+static u64 make_profile(int copies, int dup, int stripes, int parity)
 {
+	if(copies == 1 && !dup && stripes == 0 && parity == 0)
+		return 0;
+	else if(copies == 2 && dup && stripes == 0 && parity == 0)
+		return BTRFS_BLOCK_GROUP_DUP;
+	else if(copies == 2 && !dup && stripes == 0 && parity == 0)
+		return BTRFS_BLOCK_GROUP_RAID1;
+	else if(copies == 2 && !dup && stripes == -1 && parity == 0)
+		return BTRFS_BLOCK_GROUP_RAID10;
+	else if(copies == 1 && !dup && stripes == -1 && parity == 0)
+		return BTRFS_BLOCK_GROUP_RAID0;
+	else if(copies == 1 && !dup && stripes == -1 && parity == 1)
+		return BTRFS_BLOCK_GROUP_RAID5;
+	else if(copies == 1 && !dup && stripes == -1 && parity == 2)
+		return BTRFS_BLOCK_GROUP_RAID6;
+
+	return (u64)-1;
+}
+
+static u64 parse_profile(const char *s)
+{
+	char *pos, *parse_end;
+	int copies = 1;
+	int stripes = 0;
+	int parity = 0;
+	int dup = 0;
+	u64 profile = (u64)-1;
+
+	/* Look for exact match with historical forms first */
 	if (strcmp(s, "raid0") == 0) {
 		return BTRFS_BLOCK_GROUP_RAID0;
 	} else if (strcmp(s, "raid1") == 0) {
@@ -362,12 +392,54 @@ static u64 parse_profile(char *s)
 		return BTRFS_BLOCK_GROUP_DUP;
 	} else if (strcmp(s, "single") == 0) {
 		return 0;
+	}
+
+	/* Attempt to parse new ncmspp form */
+	/* <n>c is required and n must be an unsigned decimal number */
+	copies = strtoul(s, &parse_end, 10);
+	if(parse_end == s || (*parse_end != 'c' && *parse_end != 'C'))
+		goto unknown;
+
+	/* c may be followed by d to indicate non-redundant/DUP */
+	pos = parse_end + 1;
+	if(*pos == 'd' || *pos == 'D') {
+		dup = 1;
+		pos++;
+	}
+	if(*pos == 0)
+		goto done;
+
+	/* <m>s is optional, and <m> may be an integer, or a literal "x" */
+	if(*pos == 'x' || *pos == 'X') {
+		stripes = -1;
+		parse_end = pos+1;
 	} else {
-		fprintf(stderr, "Unknown profile %s\n", s);
-		print_usage();
+		stripes = strtoul(pos, &parse_end, 10);
 	}
-	/* not reached */
-	return 0;
+	if(parse_end == pos || (*parse_end != 's' && *parse_end != 'S'))
+		goto unknown;
+
+	pos = parse_end + 1;
+	if(*pos == 0)
+		goto done;
+
+	/* <p>p is optional, and p must be an integer */
+	parity = strtoul(pos, &parse_end, 10);
+	if(parse_end == pos || (*parse_end != 'p' && *parse_end != 'P'))
+		goto unknown;
+	pos = parse_end + 1;
+	if(*pos != 0)
+		goto unknown;
+
+done:
+	profile = make_profile(copies, dup, stripes, parity);
+	if(profile == (u64)-1)
+		fprintf(stderr, "Unknown or unavailable profile '%s'\n", s);
+	return profile;
+
+unknown:
+	fprintf(stderr, "Unparseable profile '%s'\n", s);
+	return (u64)-1;
 }
 
 static char *parse_label(char *input)
@@ -1447,6 +1519,11 @@ int main(int ac, char **av)
 	printf("\nWARNING! - %s IS EXPERIMENTAL\n", BTRFS_BUILD_VERSION);
 	printf("WARNING! - see http://btrfs.wiki.kernel.org before using\n\n");
 
+	if (data_profile == (u64)-1 || metadata_profile == (u64)-1) {
+		fprintf(stderr, "Cannot handle requested replication profile. Aborting\n");
+		exit(1);
+	}
+
 	if (source_dir == 0) {
 		file = av[optind++];
 		ret = is_swap_device(file);
@@ -1666,7 +1743,7 @@ raid_groups:
 
 		flags |= BTRFS_FEATURE_INCOMPAT_RAID56;
 		btrfs_set_super_incompat_flags(super, flags);
-		printf("Setting RAID5/6 feature flag\n");
+		printf("Setting parity-RAID feature flag\n");
 	}
 
 	printf("fs created label %s on %s\n\tnodesize %u leafsize %u "
-- 
1.7.10.4

