Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:34422 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937846AbcJ1Q3v (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Oct 2016 12:29:51 -0400
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
        by zaphod.cobb.me.uk (Postfix) with ESMTP id 5EC619B918
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Oct 2016 17:29:46 +0100 (BST)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
        by black.home.cobb.me.uk (Postfix) with ESMTPS id 0379C5FBB2
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Oct 2016 17:29:45 +0100 (BST)
Subject: Re: [PATCH 3/3] btrfs-progs: Add command to check if balance op is
 req
To: linux-btrfs@vger.kernel.org
References: <1476750915-3105-1-git-send-email-divya.indi@oracle.com>
 <1476750915-3105-2-git-send-email-divya.indi@oracle.com>
 <1476750915-3105-3-git-send-email-divya.indi@oracle.com>
 <1476750915-3105-4-git-send-email-divya.indi@oracle.com>
 <c451366c-089c-5fe0-bfdb-ba3941f79d9d@cn.fujitsu.com>
 <84b80642-1c56-127c-ce1c-e38fd3bf0043@oracle.com>
 <20161028152005.GJ12522@twin.jikos.cz>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <e0d9106a-3aa4-15df-dc97-81be7b4b687c@cobb.uk.net>
Date: Fri, 28 Oct 2016 17:29:45 +0100
MIME-Version: 1.0
In-Reply-To: <20161028152005.GJ12522@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 28/10/16 16:20, David Sterba wrote:
> I tend to agree with this approach. The usecase, with some random sample
> balance options:
> 
>  $ btrfs balance start --analyze -dusage=10 -musage=5 /path

Wouldn't a "balance analyze" command be better than "balance start
--analyze"? I would have guessed the latter started the balance but
printed some analysis as well (before or, probably more usefully,
afterwards).

There might, of course, be some point in a (future)

$ btrfs balance start --if-needed -dusage=10 -musage=5 /path

command.

