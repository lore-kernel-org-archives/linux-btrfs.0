Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757601AbaGWJ5h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 05:57:37 -0400
Date: Wed, 23 Jul 2014 11:57:34 +0200
From: David Sterba <dsterba@suse.cz>
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Testing with flaky disk
Message-ID: <20140723095734.GK1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAN05THRDjQ0eM4n=4kO61C3aEf06ZGQKu8ABCtO1MK5vZjDQEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAN05THRDjQ0eM4n=4kO61C3aEf06ZGQKu8ABCtO1MK5vZjDQEQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 21, 2014 at 01:34:04PM -0700, ronnie sahlberg wrote:
> I started working on a test tool for SCSI initiators and filesystem folks.
> It is a iSCSI target that implements a bad flaky disks where you
> can set precise controls of how/what is broken which you can use to test
> error and recovery paths in the initiator/filesystem.
> 
> The tool is available at :
> https://github.com/rsahlberg/flaky-stgt.git
> and is a modified version of the TGTD iscsi target.

Looks interesting and more flexible than dm-flakey. I like the
possibility to inject all sorts of low-level scsi errors.

> Right now it is just an initial prototype and it needs more work to
> add more types of errors as well as making it more userfriendly.

It would be good to add a way to simulate silent data corruption,
both random or for given block offset, reads and writes.
