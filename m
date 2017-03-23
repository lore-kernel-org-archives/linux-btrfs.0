Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33653 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751252AbdCWLXn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Mar 2017 07:23:43 -0400
Received: by mail-io0-f193.google.com with SMTP id f84so12932039ioj.0
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Mar 2017 04:23:42 -0700 (PDT)
Subject: Re: Cross-subvolume rename behavior
To: Hugo Mills <hugo@carfax.org.uk>, Sean Greenslade <sean@seangreenslade.com>,
        linux-btrfs@vger.kernel.org
References: <20170323053723.GA32087@coach>
 <20170323100950.GI11714@carfax.org.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <8f7c4e4b-f311-27d7-f312-235dafbac30e@gmail.com>
Date: Thu, 23 Mar 2017 07:23:40 -0400
MIME-Version: 1.0
In-Reply-To: <20170323100950.GI11714@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-03-23 06:09, Hugo Mills wrote:
> On Wed, Mar 22, 2017 at 10:37:23PM -0700, Sean Greenslade wrote:
>> Hello, all. I'm currently tracking down the source of some strange
>> behavior in my setup. I recognize that this isn't strictly a btrfs
>> issue, but I figured I'd start at the bottom of the stack and work my
>> way up.
>>
>> I have a server with a btrfs filesystem on it that I remotely access on
>> several systems via an sshfs mount. For the most part this works
>> perfectly, but I just discovered that moving files between subvolumes on
>> that mount fails with a confusing "Operation not permitted" error.
>>
>> After doing some digging, it turns out it's not actually a permissions
>> error. If I do the same operation locally on the server, it succeeds,
>> but an strace of the mv reveals that the rename() syscall returns EXDEV.
>> The mv util takes this as a sign to fall back on the copy-and-delete
>> routine, so the move succeeds. Unfortunately, it seems that somewhere in
>> sshfs, sftp, or fuse, the EXDEV is getting turned into a generic
>> failure, which mv apparently interprets as "permission denied".
>>
>> So my question for the btrfs devs: is rename()-ing across subvolumes
>> not feasible, or is this simply a case of no one has implemented that
>> yet?
>
>    Direct rename (using rename(2)) isn't possible across subvols,
> which is what the EXDEV result indicates. The solution is exactly what
> mv does, which is reflink-and-delete (which is cheaper than
> copy-and-delete, because no data is moved). In theory, you probably
> could implement rename across subvolumes in the FS, but it would just
> be moving the exact same operations from userspace to kernel space.
Doing so though would have the advantage that it theoretically could be 
made (almost) atomic like a normal rename is, whereas the fallback in mv 
is absolutely not atomic.
>
>    I think that the solution here is for the sshfs stack to be fixed
> so that it passes the EXDEV up to the mv command properly, and passes
> the subsequent server-side copy (reflink) back down correctly.
This would be wonderful in theory, but it can't pass down the reflink, 
because the SFTP protocol (which is what sshfs uses) doesn't even have 
the concept of reflinks, so implementing this completely would require a 
revision to the SFTP protocol, which I don't see as likely to happen.
