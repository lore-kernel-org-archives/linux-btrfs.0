Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:58783 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab3BZKhr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 05:37:47 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH, RFC] btrfs-progs: require mkfs -f force option to overwrite filesystem or partition table
Date: Tue, 26 Feb 2013 11:37:45 +0100
Cc: Tsutomu Itoh <t-itoh@jp.fujitsu.com>, Eric Sandeen <sandeen@redhat.com>,
        chris.mason@fusionio.com, Stefan Behrens <sbehrens@giantdisaster.de>,
        David Sterba <dsterba@suse.cz>
References: <511D2D2B.8040804@redhat.com> <512BFCD1.3030709@redhat.com> <512C3230.8020305@jp.fujitsu.com> (sfid-20130226_100038_658757_45BCF698)
In-Reply-To: <512C3230.8020305@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201302261137.46319.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 26. Februar 2013 schrieb Tsutomu Itoh:
> >> Therefore I want you to revert
> >> commit:2a2d8e1962e8b6cda7b0a7584f6d2fb95d442cb6.
> >>
> >>    btrfs-progs: require mkfs -f force option to overwrite filesystem
> >>or partition table
> >>
> >> How do you think about it?
> > 
> > What if you submit a patch to look at an environment variable,
> > BTRFS_CLOBBERS_ALL=1 which causes it to not require -f to overwrite?
> > Then you can just set it once at the top of your test environment,
> > and not change every instance?
> 
> Yes. But,
>  >> (Most of my test scripts fails without -f. So I'll always type
> "mkfs.btrfs -f") is one example.
> 
> Almost everyone types "mkfs.btrfs -f" (or BTRFS_CLOBBERS_ALL=1 :)
> unconditionally, I think.
> So, I think -f option is almost meaningless.

No.

I don´t.

And I teach not to in my trainings as well.

Everyone who uses rm -rf by default even just for deleting a single file does 
it as long as he or she deleted his / her home directory or something.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
