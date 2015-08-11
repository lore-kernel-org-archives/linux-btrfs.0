Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7129 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965062AbbHKPk7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Aug 2015 11:40:59 -0400
Message-ID: <55CA177D.1050004@fb.com>
Date: Tue, 11 Aug 2015 11:40:45 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, <dsterba@suse.com>, <clm@fb.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:8113! (4.1.3 kernel)
References: <20150706212156.GY17274@merlins.org> <20150710134348.GB15535@suse.cz> <20150712010229.GA5284@merlins.org> <20150723115558.GQ6306@suse.cz> <20150724162446.GH30815@merlins.org> <20150803035130.GL24824@merlins.org> <20150811050758.GF29259@merlins.org>
In-Reply-To: <20150811050758.GF29259@merlins.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/11/2015 01:07 AM, Marc MERLIN wrote:
> On Sun, Aug 02, 2015 at 08:51:30PM -0700, Marc MERLIN wrote:
>> On Fri, Jul 24, 2015 at 09:24:46AM -0700, Marc MERLIN wrote:
>>>>>> Screenshot: https://urldefense.proofpoint.com/v1/url?u=http://marc.merlins.org/tmp/btrfs_crash.jpg&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=BIMTuuT5G3PNqsD7rUX5Uzfyd1xL9vQIECC7sPpJh5U%3D%0A&s=5a4e737cf6e23a884121a0bd2c935edb9e7011394b6b59b109c11716a562000b
>>>>
>>>> So it's 32bit system, 3.19.8, crashing during snapshot deletion and
>>>> backref walking. EIP is in do_walk_down+0x142. I've tried to match it to
>>>> the sources on a local 32bit build, but it does not point to the
>>>> expected crash site:
>>>
>>> Thanks for looking.
>>> Unfortunately it's a mythtv where if I put a 64bit kernel, other things
>>> go wrong with the 32bit userland/64bit kernel split.
>>> But I'll put a newer 64bit kernel on it to see what happens and report
>>> back.
>>
>> I got home, built the last kernel and got netconsole working.
>> 4.1.3/64bit and 32bit crash the same way.
>
> So, it's been several weeks that I can't use this filesystem.
> Is anyone interested in fixing the kernel bug before I wipe it?
> (as in, even if the FS is corrupted, it should not crash the kernel)
>


 From a48cf7a9ae44a17d927df5542c8b0be287aee9ed Mon Sep 17 00:00:00 2001
From: Josef Bacik <jbacik@fb.com>
Date: Tue, 11 Aug 2015 11:39:37 -0400
Subject: [PATCH] Btrfs: kill BUG_ON() in btrfs_lookup_extent_info()

Replace it with an ASSERT(0) for the developers and an error for not the
developers.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
  fs/btrfs/extent-tree.c | 7 +++++--
  1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5411f0a..f7fb120 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -818,7 +818,11 @@ search_again:
  			BUG();
  #endif
  		}
-		BUG_ON(num_refs == 0);
+		if (num_refs == 0) {
+			ASSERT(0);
+			ret = -EIO;
+			goto out_free;
+		}
  	} else {
  		num_refs = 0;
  		extent_flags = 0;
@@ -859,7 +863,6 @@ search_again:
  	}
  	spin_unlock(&delayed_refs->lock);
  out:
-	WARN_ON(num_refs == 0);
  	if (refs)
  		*refs = num_refs;
  	if (flags)
-- 
2.1.0

