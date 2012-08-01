Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:52613 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab2HAGgo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Aug 2012 02:36:44 -0400
Message-ID: <5018CE66.6050609@csamuel.org>
Date: Wed, 01 Aug 2012 16:36:22 +1000
From: Chris Samuel <chris@csamuel.org>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>,
        =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>,
        linux-ext4@vger.kernel.org, axboe@kernel.dk,
        Milan Broz <mbroz@redhat.com>
Subject: Re: How can btrfs take 23sec to stat 23K files from an SSD?
References: <201207222135.11159.Martin@lichtvoll.de> <20120202124241.GW16796@shiny> <20120718220446.GB3888@merlins.org> <20120722185848.GA10089@merlins.org> <201207222135.11159.Martin@lichtvoll.de> <20120722204428.GC3925@merlins.org> <20120722224145.GC12951@merlins.org> <20120723064202.GB6931@merlins.org> <20120727110835.GA6933@shiny> <20120727184238.GA6713@merlins.org> <20120801060135.GH12695@merlins.org>
In-Reply-To: <20120801060135.GH12695@merlins.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/08/12 16:01, Marc MERLIN wrote:

> Third, A freshly made ntfs filesystem through fuse is actually FASTER!

Could it be that Samsungs FTL has optimisations in it for NTFS ?

A horrible thought, but not impossible..

-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
