Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22819 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754414AbcITOYu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 10:24:50 -0400
Subject: Re: [RFC] Preliminary BTRFS Encryption
To: David Sterba <dsterba@suse.cz>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
 <20160916011213.GV22388@dastard> <nrg4mh$bkn$1@blaine.gmane.org>
 <20160917043829.GC21290@hungrycats.org> <20160917184510.GD933@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Alex Elsayed <eternaleye@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <f75de8d4-8f18-8118-4af3-f20642f609fd@oracle.com>
Date: Tue, 20 Sep 2016 22:26:28 +0800
MIME-Version: 1.0
In-Reply-To: <20160917184510.GD933@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




Hi David,

On 09/18/2016 02:45 AM, David Sterba wrote:
> On Sat, Sep 17, 2016 at 12:38:30AM -0400, Zygo Blaxell wrote:
>> There's also a nasty problem with the extent tree--there's only one per
>> filesystem, it's shared between all subvols and block groups, and every
>> extent in that tree has back references to the (possibly encrypted) subvol
>> trees.  I'll leave that problem as an exercise for other readers.  ;)
>
> A design point that I'm not mentioning for the first time: there would
> be per-subvolume group extent trees, ie. a set of subvolumes with
> attached extent tree where similar to what we have now. So, encrypted
> and unencrypted extent metadata will never be mixed.
> (the crypto key questions are not addressed here)
>
> This hasn't been implemented but I'm making sure this will be possible
> when somebody mentions changes to the extent tree or blockgroup reworks
> (to actually solve other problems).

  Now I remember this was told before, sorry this slipped my mind.

Thanks, Anand


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
