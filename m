Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46195 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757601Ab2EYRj0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 May 2012 13:39:26 -0400
Received: by bkcji2 with SMTP id ji2so940077bkc.19
        for <linux-btrfs@vger.kernel.org>; Fri, 25 May 2012 10:39:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB9VWqBsLJ0QVSrUvig0fQe7vyx-3CV7e8QhQkGEb0CG-UqRkQ@mail.gmail.com>
References: <CAB9VWqAF1Ur-Mg1g2Qae3e4CvhnY_-89i8_7sWsGYHG=4=DUHg@mail.gmail.com>
	<CAB9VWqBsLJ0QVSrUvig0fQe7vyx-3CV7e8QhQkGEb0CG-UqRkQ@mail.gmail.com>
Date: Fri, 25 May 2012 11:39:24 -0600
Message-ID: <CAE5mzvgMS13-38faEbzaT8RZ8dZmp8mJwDL5vEn-5ypVjTjt=g@mail.gmail.com>
Subject: Re: Btrfs, snapshots and atime problems
From: cwillu <cwillu@cwillu.com>
To: Alexander Block <ablock84@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 25, 2012 at 9:25 AM, Alexander Block
<ablock84@googlemail.com> wrote:
> On Fri, May 25, 2012 at 5:15 PM, Alexander Block
> <ablock84@googlemail.com> wrote:
>> Hello,
>>
>> I would like to start a discussion on atime in Btrfs (and possibly
>> other filesystems with snapshot support).
>>
>> As atime is updated on every access of a file or directory, we get
>> many changes to the trees in btrfs that as always trigger cow
>> operations. This is no problem as long as the changed tree blocks are
>> not shared by other subvolumes. Performance is also not a problem, no
>> matter if shared or not (thanks to relatime which is the default).
>> The problems start when someone starts to use snapshots. If you for
>> example snapshot your root and continue working on your root, after
>> some time big parts of the tree will be cowed and unshared. In the
>> worst case, the whole tree gets unshared and thus takes up the double
>> space. Normally, a user would expect to only use extra space for a
>> tree if he changes something.
>> A worst case scenario would be if someone took regular snapshots for
>> backup purposes and later greps the contents of all snapshots to find
>> a specific file. This would touch all inodes in all trees and thus
>> make big parts of the trees unshared.

I think you're working from a incorrect understanding: the atime
update (metadata) will not cause the data to be de-cow'ed.  Even
writing to the file will only decow the portion that was written.
