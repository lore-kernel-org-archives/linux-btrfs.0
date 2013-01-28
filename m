Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo203.cox.net ([68.230.241.218]:37985 "EHLO
	eastrmfepo203.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007Ab3A1RTN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 12:19:13 -0500
Received: from eastrmimpo306 ([68.230.241.238]) by eastrmfepo203.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130128171913.QXMG21186.eastrmfepo203.cox.net@eastrmimpo306>
          for <linux-btrfs@vger.kernel.org>;
          Mon, 28 Jan 2013 12:19:13 -0500
Message-ID: <5106B310.2000409@czarc.net>
Date: Mon, 28 Jan 2013 12:19:12 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: dsterba@suse.cz, Danny Kukawka <danny.kukawka@bisect.de>,
        jeff.liu@oracle.com
Subject: Re: [PATCH] Btrfs-progs: v2 Fix minor problems in  btrfslabel.c
References: <1359223796-8132-1-git-send-email-gene@czarc.net> <20130128161641.GB16977@twin.jikos.cz>
In-Reply-To: <20130128161641.GB16977@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/28/2013 11:16 AM, David Sterba wrote:
> On Sat, Jan 26, 2013 at 01:09:56PM -0500, Gene Czarcinski wrote:
>> Fixed indentation, replace spaces with tabs.
>> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
>>
>> Rebased; fixed compiler warnings; added space after "if"
>> Signed-off-by: Gene Czarcinski <gene@czarc.net>
>> ---
>>   btrfslabel.c | 57 +++++++++++++++++++++++++++++----------------------------
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
>
> thanks,
> david
>
No problem.   I was just going over what was integration-20130126-fix1 
and this seemed missing and also trivial.

My suggestion/recommendation is that the current set be integrated into 
stable btrfs-progs and labeled "v0.20-rc2" and after 2/3/4/5 weeks if 
there is nothing major it should become "v0.20".  There will always be 
more good patches but we need some additional points in btrfs-progs stable.

Then the next set of updates to be integrated can proceed with that as a 
base ... patches such as "su show" and getting rid of the 
legacy/deprecated programs.

Gene
