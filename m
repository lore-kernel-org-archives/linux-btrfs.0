Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4816 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753136AbaDDOMz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Apr 2014 10:12:55 -0400
Message-ID: <533EBDEA.4050704@fb.com>
Date: Fri, 4 Apr 2014 10:12:58 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Filipe David Borba Manana <fdmanana@gmail.com>,
        <linux-btrfs@vger.kernel.org>, <linuxpatches@star.c10r.facebook.com>
Subject: Re: [PATCH] Btrfs: implement inode_operations callback tmpfile
References: <1396392799-9858-1-git-send-email-fdmanana@gmail.com> <20140404135922.GV29256@twin.jikos.cz>
In-Reply-To: <20140404135922.GV29256@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/04/2014 09:59 AM, David Sterba wrote:
> On Tue, Apr 01, 2014 at 11:53:19PM +0100, Filipe David Borba Manana wrote:
>> This implements the tmpfile callback of struct inode_operations, introduced
>> in the linux kernel 3.11 [1], and implemented already by some filesystems.
>
> Nice!
>
> Btw, would be good to mention 'O_TMPFILE' at lest in the changelog.
>
>> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> Reviewed-by: David Sterba <dsterba@suse.cz>
>
>   CC: linuxpatches@star.c10r.facebook.com
>
> how many likes so far?

He got a Nice from me ;)  That's for when a like alone won't do.

It doesn't look like xfstests has an O_TMPFILE test?

-chris

