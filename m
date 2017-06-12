Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39320 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751494AbdFLMln (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 08:41:43 -0400
Date: Mon, 12 Jun 2017 14:40:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Filip Bystricky <filipbystricky@google.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs native encryption
Message-ID: <20170612124038.GF25451@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CADvCoti_3iDwXfqepMdva6E6OOis_rqqVQ4adCV1T67PVhRrOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CADvCoti_3iDwXfqepMdva6E6OOis_rqqVQ4adCV1T67PVhRrOQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 09, 2017 at 08:50:12AM -0700, Filip Bystricky wrote:
> Dear btrfs maintainers,
> Google is evaluating btrfs for its potential use in android, but
> currently the lack of native file-based encryption unfortunately makes
> it a nonstarter.

The file-based encryption is covered by the fscrypt API, that's
implemented in ext4/f2fs, so implementing that in btrfs could allow you
to start evaluating btrfs. As other pointed, the usecases with snapshots
and reflinks need to be reviewed.

> According to the FAQ (specifically the answer to
> "Does btrfs support encryption"), nobody is currently working on this.
> How up-to-date is that answer, and are there any new plans to add
> native FBE in the future?

Wiki is a snapshot of status, knowledge and best practices from mixed
times, so not everything is up to date or accurate. That no one is
working on encryption is partially true, as we've seen some proposed
patches that received objections and from my perspective are not close
to being considered for merging.

The fscrypt functionality has been designed and the API defined, so it's
a matter of implementation on the btrfs side. Anything else is in the
phase of design and prototyping.
