Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-06v.sys.comcast.net ([69.252.207.38]:52733 "EHLO
	resqmta-ch2-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751880AbaLTLX1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Dec 2014 06:23:27 -0500
Message-ID: <54955C2B.7010706@pobox.com>
Date: Sat, 20 Dec 2014 03:23:23 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, Daniele Testa <daniele.testa@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs is using 25% more disk than it should
References: <CAN6BF2Luf3ERd+ShLyUavzM3bLmy9dT918Zg17xL9T42DNVtVQ@mail.gmail.com> <54949454.9020601@fb.com> <549495D4.9030800@fb.com>
In-Reply-To: <549495D4.9030800@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/19/2014 01:17 PM, Josef Bacik wrote:
> tl;dr: Cow means you can in the worst case end up using 2 * filesize -
> blocksize of data on disk and the file will appear to be filesize.  Thanks,

Doesn't the worst case more like N^log(N) (when N is file in blocksize) 
in the pernicious case?

Staggered block overwrites can "peer down" through gaps to create more 
than two layers of retention. The only real requirement is that each 
layer get smaller than the one before it so as to leave some of each of 
it's predecessor visible.

So if I make a file size N blocks, then overwrite it with N-1 blocks, 
then overwrite it again with N-2 blocks (etc). I can easily create a 
deep slop of obscured data.

[-----------------]
[----------------]
[---------------]
[--------------]
[-------------]
[------------]
[-----------]
[----------]
[---------]
(etc...)


Or would I have to bracket the front and back

----------
  --------
   ------

Or could I bracket the sides

---------
---- ----
---   ---
--     --
-       -

There's got to be pahological patterns like this that can end up with a 
heck of a lot of "hidden" data.
