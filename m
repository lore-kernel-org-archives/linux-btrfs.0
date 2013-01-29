Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24129 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3A2DFr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 22:05:47 -0500
Message-ID: <51073C4F.5050907@oracle.com>
Date: Tue, 29 Jan 2013 11:04:47 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: Gene Czarcinski <gene@czarc.net>, linux-btrfs@vger.kernel.org,
        Danny Kukawka <danny.kukawka@bisect.de>
Subject: Re: [PATCH] Btrfs-progs: v2 Fix minor problems in  btrfslabel.c
References: <1359223796-8132-1-git-send-email-gene@czarc.net> <20130128161641.GB16977@twin.jikos.cz>
In-Reply-To: <20130128161641.GB16977@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

On 01/29/2013 12:16 AM, David Sterba wrote:
> On Sat, Jan 26, 2013 at 01:09:56PM -0500, Gene Czarcinski wrote:
>> Fixed indentation, replace spaces with tabs.
>> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
>>
>> Rebased; fixed compiler warnings; added space after "if"
>> Signed-off-by: Gene Czarcinski <gene@czarc.net>
>> ---
>>  btrfslabel.c | 57 +++++++++++++++++++++++++++++----------------------------
> 
> Jeff Liu has sent a series that updates the code and also fixes the
> formatting. And I'd prefer to take his series as a more extensive
> update.
> 
> Also, btrfslabel.c is another file to be removed and its contents placed
> into the right locations, like cmds-filesystem.c or util.[ch] . I didn't
> realize that during reviewing the label series.
> 
> Jeff, I suggest to add a new patch that moves the functions out of
> btrfslabel.c, so you don't have to rework the whole series again.
I'll deal with it later, Thanks for your kind suggestion.

-Jeff

