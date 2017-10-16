Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41374 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752433AbdJPNaO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 09:30:14 -0400
Date: Mon, 16 Oct 2017 15:28:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Cerem Cem ASLAN <ceremcem@ceremcem.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Why isnt NOCOW attributes propogated on snapshot transfers?
Message-ID: <20171016132826.GH3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAN4oSBcZmqh+iK7Qyd4VBcOhQDfZVAu2B7_1pL60UKCb_oX3zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAN4oSBcZmqh+iK7Qyd4VBcOhQDfZVAu2B7_1pL60UKCb_oX3zg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 15, 2017 at 04:19:23AM +0300, Cerem Cem ASLAN wrote:
> `btrfs send | btrfs receive` removes NOCOW attributes. Is it a bug or
> a feature? If it's a feature, how can we keep these attributes if we
> need to?

This is a known defficiency of send protocol v1. And there are more,
listed on
https://btrfs.wiki.kernel.org/index.php/Design_notes_on_Send/Receive#Send_stream_v2_draft
