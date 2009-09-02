From: jim owens <jowens@hp.com>
Subject: [PATCH] don't OOPs when we are not raid56
Date: Wed, 02 Sep 2009 12:32:00 -0400
Message-ID: <4A9E9E00.5080608@hp.com>
References: <1249553833.568.23.camel@macbook.infradead.org>	 <774E55AE-1639-4537-B001-E8F96311F4CD@karlsbakk.net> <1249658554.568.214.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1249658554.568.214.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

David Woodhouse wrote:

> http://git.infradead.org/users/dwmw2/btrfs-raid56.git


Signed-off-by: jim owens <jowens@hp.com>
---
  fs/btrfs/volumes.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 95babc1..913c29f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2895,7 +2895,7 @@ again:
  		multi->num_stripes = num_stripes;
  		multi->max_errors = max_errors;
  	}
-	if (raid_map_ret) {
+	if (raid_map) {
  		sort_parity_stripes(multi, raid_map);
  		*raid_map_ret = raid_map;
  	}
-- 
1.5.6.3

