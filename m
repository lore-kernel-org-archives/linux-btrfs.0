Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx-relay39-hz1.antispameurope.com ([94.100.133.215]:60566 "EHLO
        mx-relay39-hz1.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752171AbeAIKUO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Jan 2018 05:20:14 -0500
Date: Tue, 9 Jan 2018 11:12:33 +0100
From: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
To: <praiskup@redhat.com>, <eggert@cs.ucla.edu>, <bug-tar@gnu.org>
CC: <mhw@netris.org>, <linux-btrfs@vger.kernel.org>
Subject: Re: [Bug-tar] [PATCH] Re: Detection of sparse files is broken on
 btrfs
Message-ID: <5a549591.KtC5JX9LhFYKXmZ1%Joerg.Schilling@fokus.fraunhofer.de>
References: <87fu7hccci.fsf@netris.org>
 <5923534.bzxSDfjug7@nb.usersys.redhat.com>
 <ae4ec76e-7681-6338-cec5-c0be658df62d@cs.ucla.edu>
In-Reply-To: <ae4ec76e-7681-6338-cec5-c0be658df62d@cs.ucla.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Paul Eggert <eggert@cs.ucla.edu> wrote:

> If we can lseek for holes, then why not just do that? We shouldn't need 
> special-case code for btrfs per se. Any filesystem where we can lseek for holes 
> should take advantage of that optimization.

This is what star uses since 13 years ;-)

Jörg

-- 
 EMail:joerg@schily.net                    (home) Jörg Schilling D-13353 Berlin
    joerg.schilling@fokus.fraunhofer.de (work) Blog: http://schily.blogspot.com/
 URL: http://cdrecord.org/private/ http://sf.net/projects/schilytools/files/'
