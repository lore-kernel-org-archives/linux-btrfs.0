Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:40400 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab2FDRd3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jun 2012 13:33:29 -0400
Received: by ghrr11 with SMTP id r11so3554720ghr.19
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jun 2012 10:33:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB9VWqAbh1GEbbvbm0MjOPCocX3K7B5yVynH1VYMWV-rN_CZ7Q@mail.gmail.com>
References: <CAHf9xvYX+3sjJL3anEQD0TJLbBiSsF4Pu1aBwVjeTofNmxFMpw@mail.gmail.com>
	<CAB9VWqAoc=+9B5FLtVbDY8xWeRt+O8oJ79BQKtdhOMjMAYu2eA@mail.gmail.com>
	<CAGEjNMf5hU4wteJepU5h4r=HXs_Anf_RGawHpphq=ft76Raw=Q@mail.gmail.com>
	<CAB9VWqAbh1GEbbvbm0MjOPCocX3K7B5yVynH1VYMWV-rN_CZ7Q@mail.gmail.com>
Date: Mon, 4 Jun 2012 20:33:28 +0300
Message-ID: <CAHf9xvYUW1jbJCirNSde_A78-_K_5x+kGoOV_hQ-0O51UxuhXA@mail.gmail.com>
Subject: Re: inquiry on btrfs send/receive
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Alexander Block <ablock84@googlemail.com>
Cc: shyam btrfs <shyam.btrfs@gmail.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 4, 2012 at 6:33 PM, Alexander Block <ablock84@googlemail.com> wrote:
> On Mon, Jun 4, 2012 at 5:10 PM, shyam btrfs <shyam.btrfs@gmail.com> wrote:
>> Hi Alex, Jan,
>>
>> I was also interested in send/receive semantics & was thinking that if
>> we adhere to the semantics as in
>> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg07482.html
>> of:
>>
>> it is impossible to track the "deleted" items (files,dirs, eXtended
>> attributes). I can develop a command which compare two subvolumes an
>> extract all of this kind of information. But this command would return
>> correct information *only if*
>>   A) a subvolume is a snapshot of the other one
>>   B.1) the reference snapshot is not touched OR
>>   B.2) I have the lastgen "when" the snapshot is taken
> What I implement is basically the same, but with no transid involved. The
> comparison however takes place inside the kernel and not in user space.
>>
>> then transid/generation number could be made to work to determine the
>> differences between two subvolumes including the deletes that were
>> involved. I agree that file-clone is tricky as you pointed, but we
>> dont use it in our environment.
>>
>> Do you still see issues with it that I am missing?
>>
>> Also out of curiosity, would you mind sharing how you avoided looking
>> at transid? Would it be that all meta changes are logged in
>> tree-modification-log or equivalent?
> The btrees in btrfs have a nice feature: If you compare two trees and
> encounter a tree block that is shared with the other tree, the whole
> subtree below is shared and thus can be regarded as unchanged.
> Checking the transids does not guarantee that you skip those
> unchanged subtrees, as the transids may also change when none
> of the items change. btrfs balance may do this for example. So you
> would unnecessarily iterate and compare the whole tree in many
> cases, which will give bad performance.

Yes, I also noticed that sometimes transid gets bumped up, but there
is no actual change.

So let's say you identify that a particular part of the tree is not
shared anymore, and, say, eventually you get to a particular leaf
within that part of the tree. How would you detect that, say, a
particular INODE_ITEM (or, more difficult, an INODE_REF) is missing
from that leaf WRT to previous tree?

The property you described perhaps suggests another method to find
leafs, in which *something* has changed. (Although within a leaf, does
it make sense to decode all items and to look at their transid - those
that have them - to filter out even more?) And yes, perhaps, looking
at transid alone will bring more such potential leafs into
consideration.

However, how does this property help to determine *what* actually has
changed between the two trees? Like, for example, being able to tell
over which range of keys there possibly was a change, and iterate
within that range?

Alex.
