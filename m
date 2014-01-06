Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:10353 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbaAFBPw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 20:15:52 -0500
Message-ID: <52C9FE13.7040909@cn.fujitsu.com>
Date: Mon, 06 Jan 2014 08:51:31 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, sbehrens@giantdisaster.de
Subject: Re: [PATCH v2 03/11] btrfs: Add nocheck_int mount option.
References: <1388729434-19799-1-git-send-email-quwenruo@cn.fujitsu.com> <1388729434-19799-4-git-send-email-quwenruo@cn.fujitsu.com> <20140103171308.GQ6498@twin.jikos.cz>
In-Reply-To: <20140103171308.GQ6498@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 3 Jan 2014 18:13:08 +0100, David Sterba wrote:
> On Fri, Jan 03, 2014 at 02:10:26PM +0800, Qu Wenruo wrote:
>> Add nocheck_int mount option to disable integrity check with
>> remount option.
>>
>> +	nocheck_int disables all the debug options above.
> I think this option is not needed, the integrity checker is a
> deveoplment functionality and used by people who know what they're
> doing. Besides this would need to clean up all the data structures that
> the checker uses (see eg. btrfsic_unmount that's called only if the
> mount option is used). I see little benefit compared to the amount of
> work to make sure that disabling the checker functionality in the middle
> works properly.
>
> david
>
That's right, since most people won't enable integrity check
until checking the all-yes config or running xfstests,
it's better not to add this option.

Qu
