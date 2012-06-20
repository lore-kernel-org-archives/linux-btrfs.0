Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32931 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758013Ab2FTUFq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 16:05:46 -0400
MIME-Version: 1.0
In-Reply-To: <4FE2125A.5080806@libero.it>
References: <1340188512-5761-1-git-send-email-ablock84@googlemail.com>
	<4FE205CF.9020509@libero.it>
	<CAB9VWqB8z_faPNRJo8+9JWsQFDe507iTxwQK4sctUYGF9zCL4Q@mail.gmail.com>
	<1340215644.6961.12.camel@cwalton-XPS-8300>
	<4FE2125A.5080806@libero.it>
Date: Wed, 20 Jun 2012 22:05:45 +0200
Message-ID: <CAB9VWqAF5QS6BppN7Xei6JGsDU9ThBpcipk4r=PCwzu8c2AKgQ@mail.gmail.com>
Subject: Re: [PATCH] Allow cross subvolume reflinks (2nd attempt)
From: Alexander Block <ablock84@googlemail.com>
To: kreijack@inwind.it
Cc: Calvin Walton <calvin.walton@kepstin.ca>, linux-btrfs@vger.kernel.org,
        dave@jikos.cz, hch@infradead.org, linux-fsdevel@vger.kernel.org,
        chris.mason@fusionio.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 20, 2012 at 8:11 PM, Goffredo Baroncelli <kreijack@libero.it> wrote:
>
> Yes please, could someone explain the reason behind this decision ? May
> be there are valid reasons, I am asking only to know which ones ?
>
The reason is that at the moment no user visible operations span mount
boundaries
and there were discussion on whether this should be allowed for the
clone ioctl or
not. For the moment, I would already be happy to have cross subvolume reflinks
which do not span mount points, this would already be much more as we have at
the moment.
