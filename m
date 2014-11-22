Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-02v.sys.comcast.net ([96.114.154.161]:33046 "EHLO
	resqmta-po-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751865AbaKVWzK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Nov 2014 17:55:10 -0500
Message-ID: <5471144C.8090601@pobox.com>
Date: Sat, 22 Nov 2014 14:55:08 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Volume/subvolume UUID uniqueness, was: BTRFS messes up snapshot
 LV with origin
References: <CAJCQCtRPa9fBmvBRt+RLbGy8iSUKq1_=2oZuioTKSaWAieBihQ@mail.gmail.com> <54711351.1040208@pobox.com>
In-Reply-To: <54711351.1040208@pobox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/22/2014 02:50 PM, Robert White wrote:
> Take a couple snapshots of a subvolume, and then
> send those subvolumes to another file system with send/receive, and then
> do "btrfs subvolume list -u -q" on the two filesystems and tell me that
> mess makes sense. Or try to recreate a subvolume from its snapshot in a
> way that doesn't shatter the relationships in your backup scheme. (I'm
> researching for a couple patches but I'm not expecting a warm reception
> given the silence to date).

(ASIDE In particular use "btrfs sub send -c SNAP1 SNAP2" and then "btrfs 
sub send -c SNAP2 SNAP3" etc before doing the "btrfs sub list -u -q" to 
view the mess I speak of.)

