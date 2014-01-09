Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59089 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823AbaAIO6T convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jan 2014 09:58:19 -0500
From: Chris Mason <clm@fb.com>
To: "1i5t5.duncan@cox.net" <1i5t5.duncan@cox.net>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: How does btrfs handle bad blocks in raid1?
Date: Thu, 9 Jan 2014 14:58:11 +0000
Message-ID: <1389279515.23310.52.camel@ret.masoncoding.com>
References: <CAFvQSYRWBqMdAm-9yWhv4SS1YW-LB71iOZvgkNPc9BG3Wh7erw@mail.gmail.com>
	 <20140109104247.GH15634@carfax.org.uk>
	 <pan$ab233$2067aff9$a13049e6$e769dc55@cox.net>
In-Reply-To: <pan$ab233$2067aff9$a13049e6$e769dc55@cox.net>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2014-01-09 at 12:41 +-0000, Duncan wrote:
+AD4- Hugo Mills posted on Thu, 09 Jan 2014 10:42:47 +-0000 as excerpted:
+AD4- 
+AD4- +AD4- On Thu, Jan 09, 2014 at 11:26:26AM +-0100, Clemens Eisserer wrote:
+AD4- +AD4APg- Hi,
+AD4- +AD4APg- 
+AD4- +AD4APg- I am running write-intensive (well sort of, one write every 10s)
+AD4- +AD4APg- workloads on cheap flash media which proved to be horribly unreliable.
+AD4- +AD4APg- A 32GB microSDHC card reported bad blocks after 4 days, while a usb pen
+AD4- +AD4APg- drive returns bogus data without any warning at all.
+AD4- +AD4APg- 
+AD4- +AD4APg- So I wonder, how would btrfs behave in raid1 on two such devices? Would
+AD4- +AD4APg- it simply mark bad blocks as +ACI-bad+ACI- and continue to be operational, or
+AD4- +AD4APg- will it bail out when some block can not be read/written anymore on one
+AD4- +AD4APg- of the two devices?
+AD4- +AD4- 
+AD4- +AD4- If a block is read and fails its checksum, then the other copy (in
+AD4- +AD4- RAID-1) is checked and used if it's good. The bad copy is rewritten to
+AD4- +AD4- use the good data.
+AD4- 
+AD4- This is why I'm (semi-impatiently, but not being a coder, I have little 
+AD4- choice, and I do see advances happening) so looking forward to the 
+AD4- planned N-way-mirroring, aka true-raid-1, feature, as opposed to btrfs' 
+AD4- current 2-way-only mirroring.  Having checksumming is good, and a second 
+AD4- copy in case one fails the checksum is nice, but what if they BOTH do?
+AD4- I'd love to have the choice of (at least) three-way-mirroring, as for me 
+AD4- that seems the best practical hassle/cost vs. risk balance I could get, 
+AD4- but it's not yet possible. +AD0-:+AF4-(
+AD4- 
+AD4- For (at least) year now, the roadmap has had N-way-mirroring on the list 
+AD4- for after raid5/6 as they want to build on its features, but (like much 
+AD4- of the btrfs work) raid5/6 took about three kernels longer to introduce 
+AD4- than originally thought, and even when introduced, the raid5/6 feature 
+AD4- lacked some critical parts (like scrub) and wasn't considered real-world 
+AD4- usable as integrity over a crash and/or device failure, the primary 
+AD4- feature of raid5/6, couldn't be assured.  

I'm frustrated too that I haven't pushed this out yet.  I've been trying
different methods to keep the performance up and in the end tried to do
pile on too many other features in the patches.  So, I'm breaking it up
a bit and reworking things for faster release.

-chris

