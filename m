Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:49585 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766Ab3BCRBu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 3 Feb 2013 12:01:50 -0500
Date: Sun, 3 Feb 2013 18:01:38 +0100
From: David Sterba <dave@jikos.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: kreijack@inwind.it, Chris Mason <chris.mason@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [BTRFS-PROGS][PATCH] remove __attribute_const__ from raid6.c
Message-ID: <20130203170138.GC16594@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <510D7356.4030903@inwind.it>
 <510E8898.4050606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <510E8898.4050606@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 03, 2013 at 09:56:08AM -0600, Eric Sandeen wrote:
> +#define __attribute_const__	__attribute__((const))

__attribute__((__const__))
