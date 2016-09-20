Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29022 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752611AbcITAxt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 20:53:49 -0400
Subject: Re: [RFC] Preliminary BTRFS Encryption
To: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
 <20160916084958.GA933@twin.jikos.cz>
 <a7612c6e-00cd-29cd-e843-a60586d6c408@fb.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <1368b27c-9614-9faf-7847-9791d9b0b78e@oracle.com>
Date: Tue, 20 Sep 2016 08:55:37 +0800
MIME-Version: 1.0
In-Reply-To: <a7612c6e-00cd-29cd-e843-a60586d6c408@fb.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Hi Chris,

> Hi Anand,
>
> Thanks for sending these out.  It's an important feature and I'm glad to
> see it getting some love.
>
> Right now, the design doc is really the most important part.  The
> encryption side of things requires a layer of extra verification that we
> can't get from reviewing the code alone.  We need to sit down with the
> use cases and the workflow and make sure it meets all the requirements
> of a secure system.

  yes.

> I'm the first to admit this needs a broader consensus than just
> linux-btrfs@, and we want our reviewers to be able to go through things
> without also having to understand every line of btrfs.

  right.

> I do want to make sure that we can send/recv signed and encrypted
> subvolumes, and be able to send them again unmodified.  This will end up
> needing a revision of the send/recv protocol, but it adds a use case
> wrinkle that we need to iron out in the design docs.

  Exactly. I have this in the requirement list. So I was hesitant
  to use any page(ext4)/sector(truecrypt) related IV. BTRFS just
  uses random IV which can be accessed through xattributes. But
  certainly has crypto issues. Anyway I will cover this in the document
  for the review by crypto experts.

> I still prefer encryption at the subvolume level, but it's going to need
> to be a superset of what is already possible with the vfs interfaces. If
> we can do it with the existing interfaces, great.  If not we should be
> adding features into the generic code where it makes sense.

  Sure Chris. Thanks for your comments.

- Anand

> -chris




In this situation I was almost to drop the encrypted send/recv from my 
list, thanks for mentioning I shall keep that in the design so as of now 
as I did not use anything which is


