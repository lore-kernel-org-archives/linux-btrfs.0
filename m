From: Shen Feng <shen@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs-progs: btrfs file system size should be bigger
 then 256m
Date: Mon, 05 Jan 2009 09:23:48 +0800
Message-ID: <49616124.2050604@cn.fujitsu.com>
References: <495B0D54.7060806@cn.fujitsu.com> <495BB0AC.5070607@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Zach Brown <zach.brown@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <495BB0AC.5070607@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>


on 01/01/2009 01:49 AM, Zach Brown wrote:
>> +				if (block_count < 256*1024*1024) {
>> +					fprintf(stderr, "File system size is too small\n");
>> +					exit(1);
>> +				}
> 
> And please, if you could, include both the size that is too small and
> the size that is required in the message.
> 

Thanks. I updated the patch.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 mkfs.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index be93aaa..cb21db6 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -377,6 +377,13 @@ int main(int ac, char **av)
 				break;
 			case 'b':
 				block_count = parse_size(optarg);
+				if (block_count < 256*1024*1024) {
+					fprintf(stderr, "File system size "
+						"%llu bytes is too small, "
+						"256M is required at least\n",
+						block_count);
+					exit(1);
+				}
 				zero_end = 0;
 				break;
 			default:
