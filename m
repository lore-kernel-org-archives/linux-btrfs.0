Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:37456 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab3EEQTe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 May 2013 12:19:34 -0400
Received: by mail-oa0-f41.google.com with SMTP id k14so2911380oag.0
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 09:19:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pfci5a-c0p.ln1@hurikhan.ath.cx>
References: <CADn-QaPQ0aH1rb3rG3bE87Ka3XaLzHHeA6nwNLbQJsbB_BiXkw@mail.gmail.com>
 <h1rh5a-1lg.ln1@hurikhan.ath.cx> <CADn-QaNEdWiyKaniOhzAmaGb6p=PuZ4=FxPPPiVLZZJ3zB7xpQ@mail.gmail.com>
 <pfci5a-c0p.ln1@hurikhan.ath.cx>
From: Alexander Skwar <alexanders.mailinglists+nospam@gmail.com>
Date: Sun, 5 May 2013 18:19:13 +0200
Message-ID: <CADn-QaOzed_W7WE4SspSkpa0VNozjpmAstzkNGDhzwDYhbpB9g@mail.gmail.com>
Subject: Re: Creating recursive snapshots for all filesystems
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Kai

On Sun, May 5, 2013 at 6:03 PM, Kai Krakow <hurikhan77+btrfs@gmail.com> wrote:

> That brings in the idea how bedup seems to handle this. Maybe you want to
> take one or the other idea from there as it also has to enumerate all btrfs
> filesystems and snapshots:

Sure, will have a look. There are _certainly_ more clever ways
to do that, than what I came up with ☺

BR,

Alexander
--
=>        Google+ => http://plus.skwar.me         <==
=> Chat (Jabber/Google Talk) => a.skwar@gmail.com <==
