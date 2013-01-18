Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35259 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab3ARMI5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jan 2013 07:08:57 -0500
Date: Fri, 18 Jan 2013 13:08:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Reartes Guillermo <rtguille@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs: could not do orphan cleanup -22
Message-ID: <20130118120855.GH22785@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAPVzhpxSdjLTUhA0jVm5gLSvX9fB0N9zV6UTTQno2bANTsfGVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPVzhpxSdjLTUhA0jVm5gLSvX9fB0N9zV6UTTQno2bANTsfGVw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 17, 2013 at 05:23:17PM -0300, Reartes Guillermo wrote:
> [    7.008342] device label testfs1 devid 1 transid 4141 /dev/sdb1
> [    7.011071] btrfs: disk space caching is enabled
> >> [    7.165692] btrfs: Error removing orphan entry, stopping orphan cleanup
> >> [    7.165696] btrfs: could not do orphan cleanup -22
> >> [    8.910980] btrfs: open_ctree failed

The orphan cleaning messages are harmless (and not useful to users
anyway), not like the failed mount. As a workaround, mount it read-only
and remount read write. It should be fixed after first mount cycle.

We've seen the -22 error during testing and Josef is aware of that, so
it's going to be fixed after the checksum problems.

> [    8.944598] systemd-journald[292]: Received SIGTERM
> [   70.616949] systemd-modules-load[453]: Module 'uinput' is already loaded
> [   70.676072] systemd-udevd[457]: starting version 197
> [   70.937319] microcode: AMD CPU family 0x6 not supported
> [   71.598671] btrfs: disk space caching is enabled
> [   71.617841] device label testfs1 devid 1 transid 4143 /dev/sdb1
> [   71.619164] btrfs: disk space caching is enabled
> [   71.629969] device label fedora devid 1 transid 2038 /dev/sda2
> [   71.805339] btrfs: Error removing orphan entry, stopping orphan cleanup
> [   71.806597] btrfs: could not do orphan cleanup -22
> [   71.986601] device label testfs1 devid 1 transid 4143 /dev/sdb1
> [   72.934724] btrfs: open_ctree failed
> 
> I booted first with 3.8.0-0.rc3.git1.1.fc19 (which has a lot of
> issues) and then back with 3.7.2-201.fc18.

I don't see from the messages under which kernel it happened, but I
assume with both.

david
