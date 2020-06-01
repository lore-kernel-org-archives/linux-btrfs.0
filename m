Return-Path: <SRS0=ZM7b=7O=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E2B4C433DF
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Jun 2020 14:31:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 143EF20772
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Jun 2020 14:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgFAObD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 10:31:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:36400 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgFAObD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Jun 2020 10:31:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6CE99ACF3;
        Mon,  1 Jun 2020 14:31:03 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 421D1DA79B; Mon,  1 Jun 2020 16:30:57 +0200 (CEST)
Date:   Mon, 1 Jun 2020 16:30:57 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     "dsterba@suse.cz" <dsterba@suse.cz>,
        Johannes Thumshirn <jth@kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Richard Weinberger <richard@nod.at>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v3 2/3] btrfs: add authentication support
Message-ID: <20200601143056.GT18421@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Richard Weinberger <richard@nod.at>,
        Johannes Thumshirn <jthumshirn@suse.de>
References: <20200514092415.5389-1-jth@kernel.org>
 <20200514092415.5389-3-jth@kernel.org>
 <20200527132428.GE18421@twin.jikos.cz>
 <SN4PR0401MB3598E973D98DB9A0363BD3C29BB10@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN4PR0401MB3598E973D98DB9A0363BD3C29BB10@SN4PR0401MB3598.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, May 27, 2020 at 06:04:57PM +0000, Johannes Thumshirn wrote:
> On 27/05/2020 15:25, David Sterba wrote:
> > The key for all userspace commands needs to be specified the same way as
> > for kernel, ie. "--auth-key btrfs:foo" and use the appropriate ioctls to
> > read the key bytes.
> 
> Up to now I haven't been able to add a key to the kernel's keyring which 
> can be read back to user-space.

This needs permissions on the key and I think keys from some keyrings
cannot be read back even with the permissions set. There's an ioctl
equivalent of 'keyctl read' which I used to emulate the reading. Setting
the permissions is cumbersome, as it needs to manually craft the hexa
value, but otherwise would seems a better way than either specifying the
key payload on command line or storing it in a file.

I've looked at other projects using keys, eg. ecryptfs-utils, it uses
keyctl_read_alloc, so that seems to be the preferred way.

> How about passing in a key file, like it is done in UBIFS? Should be doable
> both with libsodium and libgcrypt.

Keyfile would be better, that's what dm-crypt uses, but still.
