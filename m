Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54599 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab2JCRi4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 13:38:56 -0400
Received: by bkcjk13 with SMTP id jk13so6289711bkc.19
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Oct 2012 10:38:54 -0700 (PDT)
Message-ID: <506C7831.6050701@gmail.com>
Date: Wed, 03 Oct 2012 19:38:57 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
MIME-Version: 1.0
To: Ilya Dryomov <idryomov@gmail.com>
CC: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 1/2] Update btrfs filesystem df command
References: <1349264596-9383-1-git-send-email-kreijack@inwind.it> <1349264596-9383-2-git-send-email-kreijack@inwind.it> <20121003150219.GB1978@zambezi.lan> <506C691E.6020506@gmail.com> <20121003172007.GA2890@zambezi.lan>
In-Reply-To: <20121003172007.GA2890@zambezi.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
On 10/03/2012 07:20 PM, Ilya Dryomov wrote:
>>>>   	filesystem_cmd_group_usage, NULL, {
>>>> >  >>-		{ "df", cmd_df, cmd_df_usage, NULL, 0 },
>>>> >  >>+		{ "df", cmd_disk_free, cmd_disk_free_usage, NULL, 0 },
>>> >  >
>>> >  >If this command is going to replace df, you should change the function
>>> >  >name back to cmd_df.
>> >
>> >  I was never convinced to use 'df'. At the beginning when I wrote the
>> >  first parser of btrfs, was suggested (not by me) to use "long"
>> >  command and allow the parser to match a contracted command until
>> >  there was any ambiguity. I suggested to use disk-free, but everybody
>> >  were confortable with df.. so I leaved it as "official name". But I
>> >  prefer for the internal code a more verbose name.
> Well, all your patch is doing is extending the functionality of an
> existing command.  The "official name" for that command is "df", and you
> are not changing its name.

I would like change the name of the command from df to disk-free. 
Unfortunately (for me) Chris ask to leaved the old name...

 > Why change the name of an existing function?

Strictly speaking, I never changed the name of the function. At the 
beginning I added another command (who was named disk-usage), then Chris 
asked to replace df with the new one. So I removed the old one.
Seeing the patch it seems that I changed the name, but the truth is that 
I added a new one then  removed the old one. Due to how the patch is 
generated it seems another thing.
But this doesn't change too much.

The point is that the function name doesn't match the command name. It 
is not the single case: look at the function cmd_send_start() 
(associated to the send command), cmd_defrag() )associated to the 
command defragment....)


BR
G.Baroncelli
>
> Thanks,
>
> 		Ilya
>

