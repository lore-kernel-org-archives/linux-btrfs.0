Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f48.google.com ([209.85.192.48]:51515 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbaLDOG4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 09:06:56 -0500
Received: by mail-qg0-f48.google.com with SMTP id q107so12396777qgd.7
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Dec 2014 06:06:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141203185311.GX12140@twin.jikos.cz>
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
 <20141130042306.GE8916@merlins.org> <547C6922.6030206@gmail.com>
 <CAH-HCWW4vUXzM6S1fCzwxdPiWHBZaf5ZNZexjRmND2WkzNK-qg@mail.gmail.com>
 <20141201184621.5dd7fcd9@natsu> <CAH-HCWV7mAz0cqO9r910aNa+wzufauvc_nOOpoB9ogDPdf7RsA@mail.gmail.com>
 <20141202031403.GZ17395@hungrycats.org> <CAH-HCWWnxqExQOexPF3jY6F1=jJA35Se5RkVw87u52F6BSic2g@mail.gmail.com>
 <20141202125610.GS12140@twin.jikos.cz> <CAH-HCWUm1CiapmHjy66DRKHa6NRegEW03es1DkK1SWv0159ZMw@mail.gmail.com>
 <20141203185311.GX12140@twin.jikos.cz>
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Thu, 4 Dec 2014 19:36:34 +0530
Message-ID: <CAH-HCWUj-3PAPDPnQcSvBm7DidzfFfiOB+v-LTOi08uTMZQaWw@mail.gmail.com>
Subject: Re: Possible to undo subvol delete?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 4, 2014 at 12:23 AM, David Sterba <dsterba@suse.cz> wrote:
> On Tue, Dec 02, 2014 at 08:45:10PM +0530, Shriramana Sharma wrote:
>> On Tue, Dec 2, 2014 at 6:26 PM, David Sterba <dsterba@suse.cz> wrote:
>> >
>> > Works for me without the root password on a Tumbleweed installation
>> > (without apparmor/selinux).
>>
>> Are you then referring to a btrfs partition mounted with user_subvol_rm_allowed?
>
> The context was 'does creating a subvolume require root password'.

Well I don't know about you, but I'm just running an openSUSE 13.2
system updated to Tumbleweed here, and even if I just hit "btrfs"
enter (no sudo, no btrfs commands) on my regular (non-root) prompt, I
am getting:

$ btrfs
Absolute path to 'btrfs' is '/usr/sbin/btrfs', so running it may
require superuser privileges (eg. root).
$

... so what to say of btrfs subvol, whether followed by crea or del!

On Kubuntu Trusty, doing the above at least gives me the help list of
btrfs subcommands and only when I try to execute some actual *action*
which requires privileges (like accessing some root-read-only file or
such) do I get an error message for not using sudo. For some (wierd)
reason SuSE (possibly thinking it's being helpful) is requiring me to
use sudo and enter password for even just *running* the btrfs
executable. If there were a way to disable this and/or get the Kubuntu
behaviour it'd be great (but of course this is not a SuSE forum!).

What seems weird to me here is that it says it *may* require root
privileges but simply drops me back to the prompt -- it doesn't seem
to check whether the executable *actually* requires root permission.
Granted, if it's under /sbin or /ust/sbin, it probably does, but the
wording is quite strange, and the behaviour stranger.

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
