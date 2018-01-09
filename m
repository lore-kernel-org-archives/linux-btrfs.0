Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zimbra.cs.ucla.edu ([131.179.128.68]:37260 "EHLO
        zimbra.cs.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932377AbeAIIEp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 03:04:45 -0500
Subject: Re: [Bug-tar] [PATCH] Re: Detection of sparse files is broken on
 btrfs
To: Pavel Raiskup <praiskup@redhat.com>, bug-tar@gnu.org
Cc: Mark H Weaver <mhw@netris.org>, linux btrfs <linux-btrfs@vger.kernel.org>
References: <87fu7hccci.fsf@netris.org>
 <5923534.bzxSDfjug7@nb.usersys.redhat.com>
From: Paul Eggert <eggert@cs.ucla.edu>
Message-ID: <ae4ec76e-7681-6338-cec5-c0be658df62d@cs.ucla.edu>
Date: Mon, 8 Jan 2018 23:59:06 -0800
MIME-Version: 1.0
In-Reply-To: <5923534.bzxSDfjug7@nb.usersys.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Pavel Raiskup wrote:
> So
> what about special casing that filesystem, where we can lseek() for holes
> anyway?

If we can lseek for holes, then why not just do that? We shouldn't need 
special-case code for btrfs per se. Any filesystem where we can lseek for holes 
should take advantage of that optimization.
