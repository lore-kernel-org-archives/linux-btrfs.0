Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52530 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751187AbaLWAdt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 19:33:49 -0500
Message-ID: <5498B86A.1020003@cn.fujitsu.com>
Date: Tue, 23 Dec 2014 08:33:46 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <clm@fb.com>
Subject: Re: Btrfs progs pre-release 3.18-rc2
References: <20141219182130.GL27601@twin.jikos.cz> <5497D3A9.8040900@cn.fujitsu.com> <20141222113745.GM27601@suse.cz>
In-Reply-To: <20141222113745.GM27601@suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: Btrfs progs pre-release 3.18-rc2
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年12月22日 19:37
> On Mon, Dec 22, 2014 at 04:17:45PM +0800, Qu Wenruo wrote:
>> I'm doing the btrfsck test framework tweaks, it will not be a big change
>> but it will change the original
>> dir hierarchy, including moving of all the binary/btrfs-image dump to
>> different dirs
>> (some dir may contains several images).
>>
>> I'm afraid it may also delay 3.18 progs release, so just info you in
>> advance.
> I think I could run the tests with rc2 codebase against the images you'd
> provide but will not merge the code changes for that release.
That's all right.
I'll send 1 or 2 small bug fix for leaf-corruption recovery for v3.18.x 
base soon.

Thanks,
Qu
