Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbbKJLuU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Nov 2015 06:50:20 -0500
Date: Tue, 10 Nov 2015 12:50:18 +0100
From: Karel Zak <kzak@redhat.com>
To: Florian Margaine <florian.margaine@commerceguys.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Fix partitioned loop devices resolve.
Message-ID: <20151110115018.GY19508@ws.net.home>
References: <56409A52.2000708@commerceguys.com>
 <20151109141256.GW19508@ws.net.home>
 <5641AC4A.2090703@commerceguys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5641AC4A.2090703@commerceguys.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 10, 2015 at 09:35:22AM +0100, Florian Margaine wrote:
> 
> 
> On 11/09/2015 03:12 PM, Karel Zak wrote:
> > On Mon, Nov 09, 2015 at 02:06:26PM +0100, Florian Margaine wrote:
> >> Instead of using string functions to extract the device name and reading
> >> this file, this patch uses the loop device API through ioctl to get the
> >> correct backing file.
> > 
> >     #define LO_NAME_SIZE    64
> > 
> >     struct loop_info64 {
> >         ...
> >         uint8_t         lo_file_name[LO_NAME_SIZE];
> >     };
> > 
> > 
> > The loopdev is based on file descriptor, the lo_file_name[] is hint
> > only and it does not have to match with the real path and the most
> > important problem is that it uses 64-bytes buffer.
> > 
> > For losetup we use LOOP_GET_STATUS64 ioctl as fallback solution only.
> 
> I was thinking that this kind of code could be used, can you confirm
> that this would be fine? Untested code:
> 
> static int resolve_loop_device()
> {
>     int ret;
>     ret = fopen('/sys/...', 'r');
>     if (ret == NULL)
>         if (errno == ENOENT)
>             return resolve_loop_device_ioctl();
> }
> 
> static int __attribute__((noinline)) resolve_loop_device_ioctl()
> {
>     /* use ioctl */
> }
> 
> This would use the normal path most of the time, and use the fallback
> only if necessary. The 64-bytes buffer issue would be mitigated.

Yep, first try /sys/... and when unsuccessful then try ioctl.

losetup example:
https://github.com/karelzak/util-linux/blob/master/lib/loopdev.c#L686

(it's probably too complex, but the basic idea is obvious)

Maybe we need libloop.so to share all these things between various
project :-)

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
