Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92523A169B
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Apr 2026 08:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775636559; cv=none; b=q2WWrQR1gHp+ZEvAElxqvYDjWFmo5BeXjwDW0oCrf/x5tofzKHm4CzZGOsr+fi93QZWuwHLGJZ+ExefKAHlxOdcx5XpriLII/SEpvtkE6mk0cGok47p3S0zyD4mlXI/C5INMRPfZOzwkACxV/gs0KNHT/xo7zRxkvt699Zywyy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775636559; c=relaxed/simple;
	bh=f+ZBfafIPEBFIVe4qmdCfYdrgI2bTT7AORj2RA8yn5A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=st+Qq2FxZPoT4DoGve4iEREI7NRfhC2oSBFmcVDFBQ9tpmAUoBe8lV3SfECmgtDb1J+J/MbAd7GeOsaj77ZjAdmIoscjm/h5oF+c+JxtUgzU+C8O3a/zCwbfleRsL9RDYusQPIFoHG3SPyXvstNwPj4aBWWqrz1rrNnanIGWqto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aRhqHw+A; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aRhqHw+A"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-7a43424f861so55928217b3.1
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Apr 2026 01:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775636556; x=1776241356; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LIwqis0iDRFjS/U1/N6iWnTQF//yIE6qnaNO6N3lNzY=;
        b=aRhqHw+A8pGq1cpPoNWZXVYZbxdevCsdm8fttqmV97P0tyBf1Iyfnj1ObqQ9H6OrSY
         0TLBMoGXTTNsD8aIQ7uMNCYlRRbsDi3mnXreC+SFVQmOonOWG2VNkq45XsWQDK8vZlhY
         hshAJpli8+0fT/wKyx7S9R3mjb2rnY0F2HZp9aYLKOYiGvOWAdJv9MuwdPcJvOgjCHxM
         ZmZeiFFGG/2LerP6aALGuMWM9+0BvNjqL/3NPzn5MfePeNGSx1D5yl4SQjPbGDxc9z6b
         /HVl8QDt9X6LQGON7L2AQKeF7bk2bpQv7v3waxsA+ZIyvTgz4ZFZaGTn+57wdNS9NFBg
         g96w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775636556; x=1776241356;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LIwqis0iDRFjS/U1/N6iWnTQF//yIE6qnaNO6N3lNzY=;
        b=MSG3HHV/octOodZcKIIErlMmi1YH0jRgscdxVspq7WcU12cWcIOSXXpOk/GvZXgrJf
         PfIAoibgSTE3KiIO0fjDm8xGEC8gkGoy+yBRpx02hDlUBH4kX8xe670n3i3+hrHJlsmJ
         k63M6o4zM5slIKdetHeSkJtujuml+XuZvpEOgwdWqHsh3C32Eie5EB1nGPsf/8nmffcF
         XKGckauCWr8YL+ullzX8HKr322ylf0UddSf7l1V5szwfMHio/yoI2CFLMBC9PVGDQIRW
         w2pOUIr2zZvbbAmHOINOUAFzsZPzBxKpm641iui9I548RhHhOBKx/NEmE35H+emkfdwF
         GIAw==
X-Gm-Message-State: AOJu0Ywc1Oev438xfdd7v2ojrwl7SY+rD1nNhPf+VwjtemkjTkRG7hwb
	A9fQgot+DagiFhleWsmrYkzPXdCtvn5Jotz8rXQLb9B84UGZgDpqP54EXrS7TA==
X-Gm-Gg: AeBDieuMWhwFL776/gTC5BNUOee3A17raAbaUXYBNd6RV/WtMJJAv1XYem/oP7EhZRc
	CBMHA4QBG8h28usfKFH1TwC0Gpr42u/A1ST0tr7/plB6CDksyq/mSIeEm+CFSoGpaNDqrJWgbfe
	aAq7MnZosTCSyCKwan1KXg0X5//bAfvOTXGRZFw8AH0YMNhMngVxDJSEYQ0jzgmDRt9nByaMOS1
	IeSI8sLsmvgzZy7lmCMcAp7l9yRr8yKLTW3SStwadKw4IcLXUCQTYz6XmybFtfaMAt5PbODy1BY
	IzRuMIiiP1Q8J38LlBI5fMhAmZpbaEFXDjmanEezotB1Ys6bykSh68jYrqRQWyeJ8HdBoQTSE0u
	AWHsEi+/1WM3qeRZmVXQ+9g2EUT643B+qt27D3zvM7i7IHbPIIny5Nrq5tmDCmfPNVw1zqYQjx1
	mLf56WjzxYrVrakc477NS2TvxnZIn3iMdd2Red
X-Received: by 2002:a05:690c:38b:b0:79c:3750:4894 with SMTP id 00721157ae682-7a4d62587eemr217232717b3.51.1775636556421;
        Wed, 08 Apr 2026 01:22:36 -0700 (PDT)
Received: from gamma.attlocal.net ([2600:1700:5ae0:ae0:fe8:893d:c7d4:d7b5])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7a36ea2872esm82030167b3.19.2026.04.08.01.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 01:22:34 -0700 (PDT)
From: Illia Bobyr <illia.bobyr@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Illia Bobyr <illia.bobyr@gmail.com>,
	David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: balance: most filters can only be specified once
Date: Wed,  8 Apr 2026 01:21:53 -0700
Message-ID: <20260408082200.788451-1-illia.bobyr@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clarify in the documentation that only one occurrence of most filters is
actually processed.  Add a warning when more than one filter of the same
type is specified.

It would be better to show an error when the same filter is specified
more than once.  The first filter is ignore in this case, and this is
not an expected behavior - nor from the existing documentation, nor from
a "naive" understand of the filter syntax.  But as there could be
existing scripts that may be specifying the same filter more than once,
it is probably safer to show a warning and turn this into an error at a
later point in time.  Giving everyone time to update their scripts.

Signed-off-by: Illia Bobyr <illia.bobyr@gmail.com>
---
 Documentation/ch-balance-filters.rst | 18 ++++++
 cmds/balance.c                       | 96 +++++++++++++++++-----------
 2 files changed, 75 insertions(+), 39 deletions(-)

diff --git a/Documentation/ch-balance-filters.rst b/Documentation/ch-balance-filters.rst
index 46b8f..e7f6 100644
--- a/Documentation/ch-balance-filters.rst
+++ b/Documentation/ch-balance-filters.rst
@@ -15,6 +15,8 @@ right after the option without a space (this is mandatory getopt syntax), like
 A filter has the following structure: ``filter[=params][,filter=...]``
 
 To combine multiple filters use ``,``, without spaces. Example: ``-dconvert=raid1,soft``
+Note that most filters can only be specified once per block group profile
+(data/metadata/system block groups).
 
 BTRFS can have different profiles on a single device or the same profile on
 multiple device.
@@ -56,25 +58,35 @@ usage=<percent>, usage=<range>
         accept only the single value format.
         The minimum range boundary is inclusive, maximum is exclusive.
 
+        This filter can only be specified once per block group profile.
+
 devid=<id>
         Balances only block groups which have at least one chunk on the given
         device. To list devices with ids use :command:`btrfs filesystem show`.
 
+        This filter can only be specified once per block group profile.
+
 drange=<range>
         Balance only block groups which overlap with the given byte range on any
         device. Use in conjunction with ``devid`` to filter on a specific device. The
         parameter is a range specified as ``start..end``.
 
+        This filter can only be specified once per block group profile.
+
 vrange=<range>
         Balance only block groups which overlap with the given byte range in the
         filesystem's internal virtual address space. This is the address space that
         most reports from btrfs in the kernel log use. The parameter is a range
         specified as ``start..end``.
 
+        This filter can only be specified once per block group profile.
+
 convert=<profile>
         Convert each selected block group to the given profile name identified by
         parameters.
 
+        This filter can only be specified once per block group profile.
+
         .. note::
                 Starting with kernel 4.5, the ``data`` chunks can be converted to/from the
                 ``DUP`` profile on a single device.
@@ -108,12 +120,16 @@ limit=<number>, limit=<range>
         most N chunks*, equivalent to ``..N`` range syntax. Kernels prior to 4.4 accept
         only the single value format.  The range minimum and maximum are inclusive.
 
+        This filter can only be specified once per block group profile.
+
 stripes=<range>
         Balance only block groups which have the given number of stripes. The parameter
         is a range specified as ``start..end``. Makes sense for block group profiles that
         utilize striping, i.e. RAID0/10/5/6.  The range minimum and maximum are
         inclusive.
 
+        This filter can only be specified once per block group profile.
+
 soft
         Takes no parameters. Only has meaning when converting between profiles, or
         When doing convert from one profile to another and soft mode is on,
@@ -125,6 +141,8 @@ soft
         For example, this means that we can convert metadata chunks the "hard" way
         while converting data chunks selectively with soft switch.
 
+        This filter can only be specified once per block group profile.
+
 Profile names, used in ``profiles`` and ``convert`` are one of:
 
 * ``raid0``
diff --git a/cmds/balance.c b/cmds/balance.c
index a9ffa..22bde 100644
--- a/cmds/balance.c
+++ b/cmds/balance.c
@@ -90,23 +90,45 @@ static void print_range_u32(u32 start, u32 end)
 		printf("%u", end);
 }
 
-static int parse_one_filter(char *name, char *value, struct btrfs_balance_args *args)
+static int parse_one_filter(char *context, char *name, char *value,
+			    struct btrfs_balance_args *args)
 {
+#define WARN_IF_DUPLICATE_FILTER(bit_flags)				\
+	if (args->flags & (bit_flags)) {				\
+		printf("WARNING:\n");					\
+		printf("Second %s filter provided for %s.\n", name,	\
+		       context);					\
+		printf("Only the last %s filter will have any effect.\n", \
+		       name);						\
+		printf("In the future this will be an error.\n");	\
+	}
+
+#define REQUIRES_ARGUMENT()						\
+	if (!value || !*value) {					\
+		error("the %s filter requires an argument", name);	\
+		return 1;						\
+	}
+
+#define WARN_IF_ARGUMENT()						\
+	if (value) {							\
+		printf("WARNING:\n");					\
+		printf("%s filter provided with an argument for %s.\n",	\
+		       name, context);					\
+		printf("Soft filter ignores its arguments.\n");		\
+		printf("In the future this will be an error.\n");	\
+	}
+
 	if (strcmp(name, "profiles") == 0) {
-		if (!value || !*value) {
-			error("the profiles filter requires an argument");
-			return 1;
-		}
+		REQUIRES_ARGUMENT();
 		if (parse_profiles(value, &args->profiles)) {
 			error("invalid profiles argument");
 			return 1;
 		}
 		args->flags |= BTRFS_BALANCE_ARGS_PROFILES;
 	} else if (strcmp(name, "usage") == 0) {
-		if (!value || !*value) {
-			error("the usage filter requires an argument");
-			return 1;
-		}
+		WARN_IF_DUPLICATE_FILTER(BTRFS_BALANCE_ARGS_USAGE |
+					 BTRFS_BALANCE_ARGS_USAGE_RANGE);
+		REQUIRES_ARGUMENT();
 		if (parse_u64(value, &args->usage)) {
 			if (parse_range_u32(value, &args->usage_min, &args->usage_max)) {
 				error("invalid usage argument: %s", value);
@@ -127,52 +149,45 @@ static int parse_one_filter(char *name, char *value, struct btrfs_balance_args *
 			args->flags |= BTRFS_BALANCE_ARGS_USAGE;
 		}
 	} else if (strcmp(name, "devid") == 0) {
-		if (!value || !*value) {
-			error("the devid filter requires an argument");
-			return 1;
-		}
+		WARN_IF_DUPLICATE_FILTER(BTRFS_BALANCE_ARGS_DEVID);
+		REQUIRES_ARGUMENT();
 		if (parse_u64(value, &args->devid) || args->devid == 0) {
 			error("invalid devid argument: %s", value);
 			return 1;
 		}
 		args->flags |= BTRFS_BALANCE_ARGS_DEVID;
 	} else if (strcmp(name, "drange") == 0) {
-		if (!value || !*value) {
-			error("the drange filter requires an argument");
-			return 1;
-		}
+		WARN_IF_DUPLICATE_FILTER(BTRFS_BALANCE_ARGS_DRANGE);
+		REQUIRES_ARGUMENT();
 		if (parse_range_strict(value, &args->pstart, &args->pend)) {
 			error("invalid drange argument");
 			return 1;
 		}
 		args->flags |= BTRFS_BALANCE_ARGS_DRANGE;
 	} else if (strcmp(name, "vrange") == 0) {
-		if (!value || !*value) {
-			error("the vrange filter requires an argument");
-			return 1;
-		}
+		WARN_IF_DUPLICATE_FILTER(BTRFS_BALANCE_ARGS_VRANGE);
+		REQUIRES_ARGUMENT();
 		if (parse_range_strict(value, &args->vstart, &args->vend)) {
 			error("invalid vrange argument");
 			return 1;
 		}
 		args->flags |= BTRFS_BALANCE_ARGS_VRANGE;
 	} else if (strcmp(name, "convert") == 0) {
-		if (!value || !*value) {
-			error("the convert option requires an argument");
-			return 1;
-		}
+		WARN_IF_DUPLICATE_FILTER(BTRFS_BALANCE_ARGS_CONVERT);
+		REQUIRES_ARGUMENT();
 		if (parse_one_profile(value, &args->target)) {
 			error("invalid convert argument");
 			return 1;
 		}
 		args->flags |= BTRFS_BALANCE_ARGS_CONVERT;
 	} else if (strcmp(name, "soft") == 0) {
+		WARN_IF_DUPLICATE_FILTER(BTRFS_BALANCE_ARGS_SOFT);
+		WARN_IF_ARGUMENT();
 		args->flags |= BTRFS_BALANCE_ARGS_SOFT;
 	} else if (strcmp(name, "limit") == 0) {
-		if (!value || !*value) {
-			error("the limit filter requires an argument");
-			return 1;
-		}
+		WARN_IF_DUPLICATE_FILTER(BTRFS_BALANCE_ARGS_LIMIT |
+					 BTRFS_BALANCE_ARGS_LIMIT_RANGE);
+		REQUIRES_ARGUMENT();
 		if (parse_u64(value, &args->limit)) {
 			if (parse_range_u32(value, &args->limit_min, &args->limit_max)) {
 				error("Invalid limit argument: %s", value);
@@ -185,10 +200,8 @@ static int parse_one_filter(char *name, char *value, struct btrfs_balance_args *
 			args->flags |= BTRFS_BALANCE_ARGS_LIMIT;
 		}
 	} else if (strcmp(name, "stripes") == 0) {
-		if (!value || !*value) {
-			error("the stripes filter requires an argument");
-			return 1;
-		}
+		WARN_IF_DUPLICATE_FILTER(BTRFS_BALANCE_ARGS_STRIPES_RANGE);
+		REQUIRES_ARGUMENT();
 		if (parse_range_u32(value, &args->stripes_min,
 				    &args->stripes_max)) {
 			error("invalid stripes argument");
@@ -196,14 +209,19 @@ static int parse_one_filter(char *name, char *value, struct btrfs_balance_args *
 		}
 		args->flags |= BTRFS_BALANCE_ARGS_STRIPES_RANGE;
 	} else {
-		error("unrecognized balance filter: %s", name);
+		error("unrecognized balance option: %s", name);
 		return 1;
 	}
 
 	return 0;
+
+#undef WARN_IF_DUPLICATE_FILTER
+#undef REQUIRES_ARGUMENT
+#undef WARN_IF_ARGUMENT
 }
 
-static int parse_filters(char *filters, struct btrfs_balance_args *args)
+static int parse_filters(char *context, char *filters,
+			 struct btrfs_balance_args *args)
 {
 	char *this_char;
 	char *value;
@@ -218,7 +236,7 @@ static int parse_filters(char *filters, struct btrfs_balance_args *args)
 		if ((value = strchr(this_char, '=')) != NULL)
 			*value++ = 0;
 
-		if (parse_one_filter(this_char, value, args))
+		if (parse_one_filter(context, this_char, value, args))
 			return 1;
 	}
 
@@ -461,21 +479,21 @@ static int cmd_balance_start(const struct cmd_struct *cmd,
 			start_flags |= BALANCE_START_FILTERS;
 			args.flags |= BTRFS_BALANCE_DATA;
 
-			if (parse_filters(optarg, &args.data))
+			if (parse_filters("data", optarg, &args.data))
 				return 1;
 			break;
 		case 's':
 			start_flags |= BALANCE_START_FILTERS;
 			args.flags |= BTRFS_BALANCE_SYSTEM;
 
-			if (parse_filters(optarg, &args.sys))
+			if (parse_filters("system", optarg, &args.sys))
 				return 1;
 			break;
 		case 'm':
 			start_flags |= BALANCE_START_FILTERS;
 			args.flags |= BTRFS_BALANCE_METADATA;
 
-			if (parse_filters(optarg, &args.meta))
+			if (parse_filters("metadata", optarg, &args.meta))
 				return 1;
 			break;
 		case 'f':
-- 
2.51.0

