Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41494 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab3CAKT0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Mar 2013 05:19:26 -0500
Message-ID: <51308078.1030002@oracle.com>
Date: Fri, 01 Mar 2013 18:18:32 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, Zach Brown <zab@zabbo.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [bug]  mkfs.btrfs reports device busy for ext4 mounted disk
References: <5127022B.6070200@oracle.com> <20130222190325.GC22221@lenny.home.zabbo.net> <20130222223046.GN27541@twin.jikos.cz>
In-Reply-To: <20130222223046.GN27541@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>> btrfs-progs shouldn't be unconditionally trusting the backup superblocks
>> if the primary is garbage.  It should only check the backups if the user
>> specifically asks it to.
>
> Agreed. Let me add that all the rescue tools should accept a parameter
> to pick the backup superblocks. Currently fsck -s, select-super -s,
> restore -u (though I'd like see all the option names unified, 'S' is my
> candidate that would not break compatibility).


   Thank You. Have sent out a patch on this thread for your kind review.


Anand
