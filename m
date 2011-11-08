From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 7/7][V2] btrfs-progs:  get-default man page
Date: Tue, 08 Nov 2011 23:12:15 +0100
Message-ID: <2037591.As7XTDLSmZ@venice>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart3971943.TEdY3otami"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart3971943.TEdY3otami
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"



Adde the man page info for the "btrfs subvolume get-default" command

Signed off by: Goffredo Baroncelli <kreijack@inwind.it>
---
 btrfs_cmds.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 517b0de..b2fff2f 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -1244,6 +1244,16 @@ int do_change_label(int nargs, char **argv)
 }
 
 
+/**** man: btrfs subvolume get-default
+ * 
+ * \Bbtrfs\b \Bsubvolume get-default\b\I <path>\i
+ * 
+ * Query which subvolume of the filesystem <path> will be mounted
+ * as default.
+ * 
+ * Get the \Idefault\i subvolume of the filesystem \I<path>\i. 
+ ****/
+
 int do_get_default_subvol(int nargs, char **argv)
 {
 	int fd;
-- 
1.7.7.2

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--nextPart3971943.TEdY3otami
Content-Disposition: inline; filename="send-via-kmail-attach-9375-1320789398-5336.msg"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="utf-8"; name="send-via-kmail-attach-9375-1320789398-5336.msg"

diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 517b0de..b2fff2f 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -1244,6 +1244,16 @@ int do_change_label(int nargs, char **argv)
 }
 
 
+/**** man: btrfs subvolume get-default
+ * 
+ * \Bbtrfs\b \Bsubvolume get-default\b\I <path>\i
+ * 
+ * Query which subvolume of the filesystem <path> will be mounted
+ * as default.
+ * 
+ * Get the \Idefault\i subvolume of the filesystem \I<path>\i. 
+ ****/
+
 int do_get_default_subvol(int nargs, char **argv)
 {
 	int fd;
-- 
1.7.7.2

--nextPart3971943.TEdY3otami--

