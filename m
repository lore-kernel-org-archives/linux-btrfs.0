Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932443Ab3HGKs2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Aug 2013 06:48:28 -0400
Date: Wed, 7 Aug 2013 12:48:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: fdmanana@gmail.com,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH RFC] Btrfs: add support for persistent mount options
Message-ID: <20130807104825.GO5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1375813640-14063-1-git-send-email-fdmanana@gmail.com>
 <52015E8A.9000300@redhat.com>
 <CAL3q7H7e5r8bHrdR=kS2ueu8iM5q5fe6pkwm8W52fY-odMh6bw@mail.gmail.com>
 <5201652E.4000505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5201652E.4000505@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 06, 2013 at 04:05:50PM -0500, Eric Sandeen wrote:
> I was thinking (and Josef just suggested too) that making a
> dir flag, saying "everything under this dir gets compressed" might make
> more sense for that scenario than adding a whole slew of
> on-disk-persistent-mount-option code.

We have this dir flag stored in the attributes, chattr +c dir/, but this
cannot be tuned further - no way to specify the compression algorithm
(or for example the target ratio as compression hint), or we can't say
"never compress files in this dir (even if mounted with compression)"
etc. 

david
