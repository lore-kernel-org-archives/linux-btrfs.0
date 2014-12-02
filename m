Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f48.google.com ([209.85.192.48]:64729 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932304AbaLBDkg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 22:40:36 -0500
Received: by mail-qg0-f48.google.com with SMTP id q107so8619163qgd.21
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 19:40:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141202031403.GZ17395@hungrycats.org>
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
 <20141130042306.GE8916@merlins.org> <547C6922.6030206@gmail.com>
 <CAH-HCWW4vUXzM6S1fCzwxdPiWHBZaf5ZNZexjRmND2WkzNK-qg@mail.gmail.com>
 <20141201184621.5dd7fcd9@natsu> <CAH-HCWV7mAz0cqO9r910aNa+wzufauvc_nOOpoB9ogDPdf7RsA@mail.gmail.com>
 <20141202031403.GZ17395@hungrycats.org>
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Tue, 2 Dec 2014 09:10:15 +0530
Message-ID: <CAH-HCWWnxqExQOexPF3jY6F1=jJA35Se5RkVw87u52F6BSic2g@mail.gmail.com>
Subject: Re: Possible to undo subvol delete?
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 2, 2014 at 8:44 AM, Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
> This is consistent with the
> way lvm2 and mdadm work when presented with data-losing or otherwise
> questionable commands and parameters.  It will break scripts, but btrfs
> users should still be expecting that for a while as undesirable default
> behaviors are identified.

Ah so there *is* precedent for my hunch that deleting subvols should
be different than deleting ordinary files and folders... :-)

> OTOH maybe there is no issue with the current behavior.  Only root can
> delete subvolumes, and maybe we assume root knows what they're doing?

Well in office environs, where the root password is with a certain
person only, then that's fine because that person is going to be wary
of doing anything that's make others angry at them, but on single-user
systems, one's regular password *is* the root password and the
situation is such that because ordinary (and mostly non-destructive)
things like installing requires entering it, so one gets accustomed to
entering it without too much thought, leading to the requirement for
such safety nets.

(Perhaps like in banks, we should have a two-password system, one for
destructive actions, so the user is forced to apply thought to what
they are approving!)

> On a side note...only root can delete subvolumes, but non-root users
> can create them, which results in...this:

Not sure about your Debian system, but my openSUSE Tumbleweed (with
kernel 3.17.2 and btrfsprogs 3.17) requires me to enter the root
password before creating a subvol (or in fact running anything under
/sbin or /usr/sbin).

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
