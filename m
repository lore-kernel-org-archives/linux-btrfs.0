Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:34014 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751829AbdIGRKE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Sep 2017 13:10:04 -0400
Received: by mail-pf0-f181.google.com with SMTP id e1so465678pfk.1
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Sep 2017 10:10:04 -0700 (PDT)
Date: Thu, 7 Sep 2017 10:10:01 -0700
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 3/7] Move Btrfs RCU string to common library
Message-ID: <20170907171001.GA17057@vader.DHCP.thefacebook.com>
References: <cover.1503470354.git.osandov@fb.com>
 <1270f0e6bfea72e136a42c058afce74f01deab62.1503470354.git.osandov@fb.com>
 <20170906151506.GT31874@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170906151506.GT31874@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 06, 2017 at 05:15:06PM +0200, David Sterba wrote:
> On Tue, Aug 22, 2017 at 11:46:01PM -0700, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > The RCU-friendly string API used internally by Btrfs is generic enough
> > for common use. This doesn't add any new functionality but instead just
> > moves the code and documents the existing API.
> 
> Ok for the changes, but please drop anything that just reformats the
> argument list and/or shifts the long strings out of 80 columns. I
> personally hate the "arguments aligned under the opening (" style

Well that's the kernel style ;)

> and can somehow live with that in new code, but if it's part of a patch
> that's pure noise as I have to read all the changed lines and figure out
> if they really are different or not. Thanks.

I only reflowed calls where I changed something, so that shouldn't be an
issue. If you really prefer I can resend it without reflowing anything,
but that's going to leave the code looking worse than before.
