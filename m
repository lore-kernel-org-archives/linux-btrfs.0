Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:53407 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751366AbdJaUAH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 16:00:07 -0400
Received: by mail-io0-f173.google.com with SMTP id 189so1401885iow.10
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 13:00:07 -0700 (PDT)
Subject: Re: btrfs-subv-backup v0.1b
To: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
Cc: Btrfs ML <linux-btrfs@vger.kernel.org>
References: <cc9e6302-125b-b120-cc45-35a2e12a3d6a@gmail.com>
 <973325765.400970.1509453637439.JavaMail.zimbra@helmholtz-muenchen.de>
 <a9accdcd-9f0a-86a2-64a9-faaf19d882cd@gmail.com>
 <551550025.428652.1509468869372.JavaMail.zimbra@helmholtz-muenchen.de>
 <56f78e50-bfc1-66cc-141e-41cfa446f855@gmail.com>
 <2032233997.441324.1509479675722.JavaMail.zimbra@helmholtz-muenchen.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <b248c184-c7c9-f352-15d1-98b8830a347d@gmail.com>
Date: Tue, 31 Oct 2017 16:00:03 -0400
MIME-Version: 1.0
In-Reply-To: <2032233997.441324.1509479675722.JavaMail.zimbra@helmholtz-muenchen.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-31 15:54, Lentes, Bernd wrote:
> ----- On Oct 31, 2017, at 6:00 PM, Austin S. Hemmelgarn ahferroin7@gmail.com wrote:
> 
>> Assuming you're careful about how you install it (that is, put it in a
>> custom prefix that isn't in $PATH), you could always build a local
>> version of Python.  Once you've got that, it's pretty trivial to change
>> the #! line at the beginning of the script to point to the appropriate
>> location.
>>
>> For what it's worth, it shouldn't be _too_ hard to get the script
>> working with Python 2.7.  The only big syntax difference that's liable
>> to be an issue is the except clauses.  I'll take a look at this and see
>> if I can't get it working for both 3.X and 2.7.
> 
> Austin,
> 
> do i understand correctly what i've read on github, that your script is worthless for SLES because they mount the subvolumes ?
> "this of course does not work if you explicitly mount subvolumes, but the only distro I know of that does that is SUSE, and they do their own thing anyway."
It's not quite worthless, it just needs a bit more effort, although 
that's not _just_ because of the subvolumes being explicitly mounted. 
There's also the fact that SUSE has an odd mix of subvolumes outside of 
the subvolume that gets mounted as root, and ones inside, which makes 
handling a SUSE root filesystem extremely complicated (though this is 
only the case if you installed with snapshot support enabled).

In short, to use this reliably for the root filesystem for OpenSUSE and 
SLES, you need to mount the top level of the root filesystem somewhere, 
and then run the script on that (and that tree is what you should be 
backing up in an ideal situation as well).

I'll look at getting the README updated to be more clear about that and 
give more specific directions tomorrow.
