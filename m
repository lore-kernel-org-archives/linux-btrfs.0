Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:37520 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaACMME (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jan 2014 07:12:04 -0500
Received: by mail-ie0-f179.google.com with SMTP id x13so15284397ief.24
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jan 2014 04:12:02 -0800 (PST)
Message-ID: <52C6A917.90502@gmail.com>
Date: Fri, 03 Jan 2014 07:12:07 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: sander@humilis.net
CC: Aastha Mehta <aasthakm@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: question regarding caching
References: <CAEx9m44ZiJLqTO1_G_rVfn+csD7_pOguEdiAjsvr3uPzna+mFA@mail.gmail.com> <52C30C8E.9020103@gmail.com> <20140103083950.GB29349@panda>
In-Reply-To: <20140103083950.GB29349@panda>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-01-03 03:39, Sander wrote:
> Austin S Hemmelgarn wrote (ao):
>> The data is probably still cached in the block layer, so after 
>> unmounting, you could try 'echo 1 > /proc/sys/vm/drop_caches'
>> before mounting again, but make sure to run sync right before
>> doing that, otherwise you might lose data.
> 
> Lose data? Where you get this from?
> 
> Sander
> 
Sorry, misread the documentation, thought it said destructive where it
really said non-destructive.
It's still a good idea to run sync before trying to clear the caches
though, cause dirty objects aren't freeable.
