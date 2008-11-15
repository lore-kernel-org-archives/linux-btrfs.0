From: hyl <heyongli@gmail.com>
Subject: [PATCH] btrfsck open_ctree sanity check
Date: Sat, 15 Nov 2008 19:29:48 +0800
Message-ID: <491EB2AC.2020506@gmail.com>
Reply-To: heyongli@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


i.e  Permission denied, open_ctree will return NULL, then lead
to a segment fault later.

Signed-off-by Yongli He <heyongli@gmail.com>
---
  btrfsck.c |    5 +++++
  1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index 801249b..86c2eeb 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -770,6 +770,11 @@ int main(int ac, char **av) {
  	cache_tree_init(&reada);

  	root = open_ctree(av[1], 0, 0);
+	if(!root){
+		perror("open");
+		exit(1);
+	}
+	

  	bits_nr = 1024;
  	bits = malloc(bits_nr * sizeof(struct block_info));
-- 
1.5.4.3
