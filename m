Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zne1-mx-out05.web4pro.fr ([185.49.20.68]:38458 "EHLO
	zne1-mta-edge-out-01.w4p.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751290AbcF2TUg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jun 2016 15:20:36 -0400
Date: Wed, 29 Jun 2016 21:20:18 +0200 (CEST)
From: Benoit GEORGELIN - Association Web4all
	<benoit.georgelin@web4all.fr>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <2137907854.307769.1467228018668.JavaMail.zimbra@web4all.fr>
In-Reply-To: <pan$4c3cf$b132bffe$aec370dd$341fc9fd@cox.net>
References: <1872105242.302575.1467216517408.JavaMail.zimbra@web4all.fr> <1981850459.302621.1467216953768.JavaMail.zimbra@web4all.fr> <pan$4c3cf$b132bffe$aec370dd$341fc9fd@cox.net>
Subject: Re: Disk quota exceeded
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Duncan, 

Thanks a lot for your answer. This give me a lot of information and a better idea of what I should do. 
I just upgraded the kernel to 4.6.3-040603-generic and i will see if it's working better with this kernel. 

If not, I will have to look to another FS with a more stable quotas :) 

Cordialement, 

Benoît 

Afin de contribuer au respect de l'environnement, merci de n'imprimer ce mail qu'en cas de nécessité

----- Mail original -----
De: "Duncan" <1i5t5.duncan@cox.net>
À: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Envoyé: Mercredi 29 Juin 2016 13:19:35
Objet: Re: Disk quota exceeded

Benoit GEORGELIN - Association Web4all posted on Wed, 29 Jun 2016 18:15:53 
+0200 as excerpted: 

> Hi dear users of the list. 
> 
> I'm new to the BTRFS file-system and I am having some problems with 
> quotas I would like to share with you what I'm facing about "Disk quota 
> exceeded" it's quite strange to me. 

Three points. 

1) Btrfs quotas have a long history of trouble, both in correctness and 
in scaling ability (btrfs balances and checks can take far longer with 
quotas enabled, often too long to be practical), and if they are now 
stable, it's only a very recent development. As a result, my 
recommendation has been and remains not to use btrfs quotas unless you 
are specifically doing so to work with the devs to test and bugfix. If 
you don't need them, simply turn them off and leave them off until they 
are known to work. If you do actually need quota functionality, you're 
far better off using a filesystem where quotas are actually stable and 
work as intended. 

> - Description of the environment I have a BTRFS volume "/var/lib/lxd" 
> I have some subvolume into "/var/lib/lxd/containers" 
> 
> The volume have quota enable Every subvolume have their quota groupe 
> created Limit of 10Go has been set to every single subvolumes 
> 
> -The problem Randomly I can't write to some of the subvolumes anymore 
> without having datas added into the subvolume. 
> I can't figure why and the subvolumes are randomly not usable with the 
> error : Disk quota exceeded 

2) I'm not sure of the current status here, but it's worth keeping in 
mind that unlike other filesystems, btrfs separates data and metadata, 
and it's possible for data to be under quota and still run out, if 
metadata takes you over quota. 

There was some talk a kernel cycle or two ago suggesting separating data 
and metadata quotas and allowing setting them either separately or 
overall capping them, but as I said, I'm not sure what the status is on 
that. 

> I did delete all the quota groups, disable quota on the volume, enable 
> the quota group again on the volume, check if quota groups were back 
> automatically as btrfs version 4 is supposed to do I added back the 
> limit 10Go Rescan Everything work just fine but some time after, I'm 
> back to over-quota on some subvolumes. 
> 
> Thanks for your help on this. 
> 
> Below, more details about the config and system point of view : 
> 
> 
> uname -a Linux lxd-virt-01b 4.2.0-30-generic #36-Ubuntu SMP Fri Feb 26 
> 00:58:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux 

3) Unfortunately, ubuntu chose what from upstream's viewpoint was a short- 
term-stable kernel. 4.2 is no longer supported upstream, and while it's 
possible that ubuntu is backporting as appropriate, on this list we track 
upstream and don't know what individual distros have backported and what 
they haven't. 

And I know for sure that 4.2 still had serious quota issues that are 
unlikely to have been fixed with backports because they never /did/ work 
right by 4.2, so the quota issues weren't regressions and thus patches to 
fix them would have been unlikely stable candidates. 

You thus have a few choices: 

4.1 and 4.4 are upstream LTS series, and continue to be supported (tho 
I'd suggest 4.4 if you'll be adopting one, as btrfs is still developing 
fast enough that we only tend to well support the last couple LTS, and 
beyond that, while critical patches will be backported to the extent 
possible, if you have a problem you're still likely to be asked to 
upgrade and see if the problem is still there if you're out of that 2 LTS 
series window, and 4.1 is getting a bit long in the tooth to be just 
upgrading to now). So one choice is to move to the latest version of one 
of them. 

Another choice would be to continue with 4.2, but get your support from 
your distro, who is better qualified to support it as they know what 
they've backported and what they haven't. 

And another choice is upgrade to current kernels, where again we 
generally support the last two series, 4.6 and 4.5 ATM. 


(FWIW, userspace version numbers are synced to kernelspace numbers. 
Backward compatibility is supported, so a good rule of thumb there is to 
run btrfs userspace at least as new as your kernel, which assuming you're 
staying in line with the latest two kernels of either current or LTS 
series, will mean your userspace doesn't get too far behind either. But 
you're on 4.4 userspace already, so are fine there.) 


-- 
Duncan - List replies preferred. No HTML msgs. 
"Every nonfree program has a lord, a master -- 
and if you use the program, he is your master." Richard Stallman 

-- 
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in 
the body of a message to majordomo@vger.kernel.org 
More majordomo info at http://vger.kernel.org/majordomo-info.html 
