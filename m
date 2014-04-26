Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw10a-lesia.wadns.net ([196.220.39.109]:19394 "EHLO
	fw10a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750728AbaDZMQT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Apr 2014 08:16:19 -0400
Message-ID: <535BA383.1090605@swiftspirit.co.za>
Date: Sat, 26 Apr 2014 14:16:03 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: dsterba@suse.cz, Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        Miao Xie <miaox@cn.fujitsu.com>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] btrfs: protect snapshots from deleting during send
References: <cover.1397572052.git.dsterba@suse.cz> <6c15e8cf5f832398461e8dbde0a02255c35fdd4b.1397572052.git.dsterba@suse.cz> <534D479E.3070200@fb.com> <20140415154412.GU29256@twin.jikos.cz> <534D57B1.6090501@fb.com> <20140415162734.GX29256@suse.cz> <534D6AAA.4010709@fb.com> <20140416133202.GZ29256@suse.cz> <534E8859.4040507@fb.com> <534E9ABD.4060300@swiftspirit.co.za> <20140416152239.GB29256@suse.cz>
In-Reply-To: <20140416152239.GB29256@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/04/16 05:22 PM, David Sterba wrote:
> On Wed, Apr 16, 2014 at 04:59:09PM +0200, Brendan Hide wrote:
>> On 2014/04/16 03:40 PM, Chris Mason wrote:
>>> So in my example with the automated tool, the tool really shouldn't be
>>> deleting a snapshot where send is in progress.  The tool should be told
>>> that snapshot is busy and try to delete it again later.
>>>
>>> It makes more sense now, 'll queue this up for 3.16 and we can try it out
>>> in -next.
>>>
>>> -chris
>> So ... does this mean the plan is to a) have userland tool give an error; or
>> b) a deletion would be "scheduled" in the background for as soon as the send
>> has completed?
> b) is current state, a) is the plan
>
> with the patch, 'btrfs subvol delete' would return EPERM/EBUSY
My apologies, I should have followed up on this a while ago already. :-/

Would having something closer to b) be more desirable if the resource 
simply disappears but continues in the background? This would be as in a 
lazy umount, where presently-open files are left open and writable but 
the directory tree has "disappeared".

I submit that, with a), the actual status is more obvious/concrete 
whereas with b+lazy), current issues would flow smoothly with no errors 
and no foreseeable future issues.

I reserve the right to be wrong, of course. ;)

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

