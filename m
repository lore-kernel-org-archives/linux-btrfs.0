Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:55008 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932365AbdBGUxx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Feb 2017 15:53:53 -0500
Subject: Re: BTRFS for OLTP Databases
To: Kai Krakow <hurikhan77@gmail.com>, linux-btrfs@vger.kernel.org
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
 <20170207140058.GA4249@carfax.org.uk>
 <CA+RUij02VMTa-L59AD9B3G+g_dS3HO7-Ttsz-qWgJtMyf58sPQ@mail.gmail.com>
 <20170207213614.5fd40981@jupiter.sol.kaishome.de>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <5913244f-a90c-2f38-7774-fb5fc7f2ea54@bouton.name>
Date: Tue, 7 Feb 2017 21:44:33 +0100
MIME-Version: 1.0
In-Reply-To: <20170207213614.5fd40981@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 07/02/2017 à 21:36, Kai Krakow a écrit :
> [...]
> I think I've read that btrfs snapshots do not guarantee single point in
> time snapshots - the snapshot may be smeared across a longer period of
> time while the kernel is still writing data. So parts of your writes
> may still end up in the snapshot after issuing the snapshot command,
> instead of in the working copy as expected.


I don't think so for three reasons :
- it's so far away from admin's expectations that someone would have
documented this in "man btrfs-subvolume",
- the CoW nature of Btrfs makes this trivial : it only has to keep old
versions of data and the corresponding tree for it to work instead of
unlinking them,
- the backup server I referred to restarted a PostgreSQL system from
snapshots about one thousand time now without a single problem while
being almost continuously being updated by streaming replication.

Lionel
