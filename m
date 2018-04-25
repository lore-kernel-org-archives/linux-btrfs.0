Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:54635 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752439AbeDYLtU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 07:49:20 -0400
Received: by mail-it0-f66.google.com with SMTP id h143-v6so19567435ita.4
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Apr 2018 04:49:20 -0700 (PDT)
Subject: Re: Btrfs progs release 4.16.1
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <20180424115857.25174-1-dsterba@suse.com>
 <pan$3f697$9cfd5cd2$6e9f2dc3$73937e71@cox.net>
 <20180425110234.GN21272@twin.jikos.cz>
 <64535388-9024-087c-3d67-4425cd4b0292@gmail.com>
 <8c13c7b8794cb214b4a34078d24f4ffd7bd56f25.camel@scientia.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <efdc6077-1eb5-5fc1-b597-4e1d03a0de0a@gmail.com>
Date: Wed, 25 Apr 2018 07:49:17 -0400
MIME-Version: 1.0
In-Reply-To: <8c13c7b8794cb214b4a34078d24f4ffd7bd56f25.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-04-25 07:29, Christoph Anton Mitterer wrote:
> On Wed, 2018-04-25 at 07:22 -0400, Austin S. Hemmelgarn wrote:
>> While I can understand Duncan's point here, I'm inclined to agree
>> with
>> David
> 
> Same from my side... and I run a multi-PiB storage site (though not
> with btrfs).
> 
> Cosmetically one shouldn't do this in a bugfix release, this should
> have really no impact on the real world.
> 
> The typical sysadmin will anyway use some stable distribution... and is
> there any which ships already 4.16?
Arch, Gentoo, and Void all have it ATM, but whether or not you want to 
consider them stable is another question.

OpenSUSE Tumbleweed and Fedora Rawhide also have 4.16, though those are 
also of questionable stability.
