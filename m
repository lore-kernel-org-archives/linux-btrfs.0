Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from shinra.asoshared.com ([65.99.237.192]:37416 "EHLO
	shinra.asoshared.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608AbbDKTh1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Apr 2015 15:37:27 -0400
Received: from mail-qk0-f181.google.com ([209.85.220.181]:36194)
	by shinra.asoshared.com with esmtpsa (TLSv1.2:AES128-GCM-SHA256:128)
	(Exim 4.85)
	(envelope-from <git@nerdoftheherd.com>)
	id 1Yh0tv-0000Rp-IP
	for linux-btrfs@vger.kernel.org; Sat, 11 Apr 2015 15:17:07 -0400
Received: by qku63 with SMTP id 63so91690046qku.3
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Apr 2015 12:17:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150303002720.GA26622@hungrycats.org>
References: <1422295551-25402-1-git-send-email-git@nerdoftheherd.com>
	<20150128125521.GD3641@twin.jikos.cz>
	<CABJ34CJR=AjAavwct4v9ud_62mSSzd3StivGHqfhNXBjGTuvjA@mail.gmail.com>
	<CABJ34CJO7rSOOOyxZy=gym7V2dzDtjnFaTXHN1Vcu_+rmaF64w@mail.gmail.com>
	<20150303002720.GA26622@hungrycats.org>
Date: Sat, 11 Apr 2015 20:17:07 +0100
Message-ID: <CABJ34CLq5uvf0WGbo_EJz6Zz2aSxBjsXT6Re8m_Vd+BHuq2VKg@mail.gmail.com>
Subject: Re: [PATCH 1/1] btrfs: Align EOF length to block in extent_same
From: Matt Robinson <git@nerdoftheherd.com>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>,
        Josef Bacik <jbacik@fb.com>
Cc: Matt Robinson <git@nerdoftheherd.com>, linux-btrfs@vger.kernel.org,
        Mark Fasheh <mfasheh@suse.de>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

As David hasn't got back to me I'm guessing that he is too busy with
other things at present. If anyone else is able to spare the time to
review my patch and give me feedback that would be very much
appreciated.

Many Thanks,

Matt

On 3 March 2015 at 00:27, Zygo Blaxell <ce3g8jdj@umail.furryterror.org> wrote:
>
> I second this.  I've seen the same behavior.
>
> Clone seems to have evolved a little further than extent-same knows about.
> e.g. there is code in the extent-same ioctl that tries to avoid doing
> a clone from within one inode to elsewhere in the same inode; however,
> the clone ioctl (which extent-same calls) has no such restriction.
>
> As Matt mentioned, clone_range seems quite happy to accept a partial block
> at EOF.  cp --reflink would be much harder to use if it did not.
>
> On Mon, Mar 02, 2015 at 08:59:11PM +0000, Matt Robinson wrote:
> > Hi David,
> >
> > Have you had a chance to look at this?  Am very happy to answer
> > further questions, adjust my implementation, provide a different kind
> > of test case, etc.
> >
> > Many Thanks,
> >
> > Matt
