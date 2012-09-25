Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:58261 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751771Ab2IYKYP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Sep 2012 06:24:15 -0400
Message-ID: <50618652.2040903@cn.fujitsu.com>
Date: Tue, 25 Sep 2012 18:24:18 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Ilya Dryomov <idryomov@gmail.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V3 1/2] Btrfs: cleanup duplicated division functions
References: <5051BAB8.7080200@cn.fujitsu.com> <505A8632.10101@cn.fujitsu.com> <505C2E62.2000400@cn.fujitsu.com> <20120923114924.GA1975@zambezi.lan> <505FBFCE.3010503@cn.fujitsu.com> <20120924164742.GN14582@twin.jikos.cz> <20120924184241.GB3098@zambezi.lan>
In-Reply-To: <20120924184241.GB3098@zambezi.lan>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	mon, 24 Sep 2012 21:42:42 +0300, Ilya Dryomov wrote:
> On Mon, Sep 24, 2012 at 06:47:42PM +0200, David Sterba wrote:
>> On Mon, Sep 24, 2012 at 10:05:02AM +0800, Miao Xie wrote:
>>> Generally, we should check the value when it is input. If not, we might
>>> run our program with the wrong value, and it is possible to cause unknown
>>> problems. So I think the above chunk is necessary.
>>
>> The difference is that giving an invalid value will exit early (your
>> version), while Ilya's version will clamp the 'usage' to the allowed
>> range during processing. From usability POV, I'd prefer to let the
>> command fail early with a verbose error eg. that the range is invalid.
> 
> I think that's the job for progs, and that's where this and a few other
> checks are currently implemented.
> 
> There is no possibility for "unknown problems", that's exactly how it's
> been implemented before the cleanup.  The purpose of balance filters
> (and the usage filter in particular) is to lower the number of chunks we
> have to relocate.  If someone decides to use raw ioctls, and supplies us
> with the invalid value, we just cut it down to a 100 and proceed.
> usage=100 is the equivalent of not using the usage filter at all, so the
> raw ioctl user will get what he deserves.
> 
> This is very similar to what we currently do with other filters.  For
> example, "soft" can only be used with "convert", and this is checked by
> progs.  But, if somebody were to set a "soft" flag without setting
> "convert" we would simply ignore that "soft".  Same goes for "drange"
> and "devid", invalid ranges, invalid devids, etc.  Pulling all these
> checks into the kernel is questionable at best, and, if enough people
> insist on it, should be discussed separately.

I think the usage is a special case that doesn't cause critical problem and
are not used everywhere. But if there is a variant which is referenced at
several places and the kernel would crash if it is invalid, in this case,
we would add the check everywhere and make the code more complex and ugly
if we don't check it when it is passed in. Besides that if we have done
lots of work before the check, we must roll back when we find the variant
is invalid, it wastes time. So I think doing the check and returning the
error number as early as possible is a rule we should follow.

Thanks
Miao
