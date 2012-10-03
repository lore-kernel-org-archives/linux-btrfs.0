Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.inserm.fr ([195.98.252.37]:33068 "EHLO smtp.inserm.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124Ab2JCGkP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 02:40:15 -0400
Message-ID: <20121003084006.39n0y2jgasg4gwgg@imp.inserm.fr>
Date: Wed, 03 Oct 2012 08:40:06 +0200
From: =?utf-8?b?U8OpYmFzdGllbg==?= Maury <sebastien.maury@inserm.fr>
To: Roman Mamedov <rm@romanrm.ru>, Goffredo Baroncelli <kreijack@gmail.com>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Hugo Mills <hugo@carfax.org.uk>,
        Goffredo Baroncelli <kreijack@inwind.it>, sebastien.maury@inserm.fr
Subject: Re: [PATCH][BTRFS-PROGS] btrfs filesystem disk-usage
References: <1349202970-6700-1-git-send-email-kreijack@gmail.com>
	<20121002234637.GF3214@shiny>
	<CAJHuE_BmvmEteSg8YgcHH3cuB27Bi-j-B=yS7Y2NFhb1L5_Aog@mail.gmail.com>
	<20121003123446.4e4db403@natsu>
In-Reply-To: <20121003123446.4e4db403@natsu>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Thanks for this patch.

Personally, i don't mind any of the propositions as the developpement  
is still in progress and may be adapted.
Furthermore, as Roman said, df is more well known for unix users.

Thanks to your work on that, i've started developing a bunch of  
scripts for monitoring btrfs disk usage (and also for monitoring  
snapper if anyone use it) through nagios.

Regards.
Sébastien

Roman Mamedov <rm@romanrm.ru> a écrit :

> On Wed, 3 Oct 2012 08:22:06 +0200
> Goffredo Baroncelli <kreijack@gmail.com> wrote:
>
>> On Wed, Oct 3, 2012 at 1:46 AM, Chris Mason   
>> <chris.mason@fusionio.com> wrote:
>> [...]
>> > I like it, thanks.  Could you please update btrfs fi df to show this
>> > instead of adding a new command though?
>>
>> Hi Chris,
>> no problem to update the patches, however I have one suggestion:
>> - leave "btrfs fi df" as is to no break any script (if any) which
>> would uses it. Hide it from the help and deprecating it in the man
>> page. This because the output is very different.
>> - renaming "btrfs fi disk-usage" in "btrfs fi disk-free", which make sense.
>
> 1) btrfs is still labeled experimental, so no script author should have
> seriously relied on utilities text output to stay unchanged long-term;
> personally I don't see modifying it (especially not in some superficial way,
> but as a part of major improvement) to be a problem;
>
> 2) "disk-usage" and "disk-free" are both way too awkward and too   
> long to type,
> compared to "fi df", and "df" is the expected shorthand for "disk   
> free" in the
> UNIX land.
>
> --
> With respect,
> Roman
>
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~
> "Stallman had a printer,
> with code he could not see.
> So he began to tinker,
> and set the software free."
>

----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.


