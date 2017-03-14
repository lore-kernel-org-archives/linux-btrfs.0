Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-34.italiaonline.it ([212.48.25.162]:48413 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750997AbdCNVaU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 17:30:20 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 0/5] raid56: variant bug fixes
References: <20170203082023.3577-1-quwenruo@cn.fujitsu.com>
 <b6ba2bec-ea6c-ca7f-5806-ba6c6dfc71f7@cn.fujitsu.com>
 <20170314134759.GB14605@twin.jikos.cz>
To: David Sterba <dsterba@suse.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        Chris Mason <clm@fb.com>
Message-ID: <04fce950-45b6-01aa-9bb7-6780e1485dd0@inwind.it>
Date: Tue, 14 Mar 2017 22:30:16 +0100
MIME-Version: 1.0
In-Reply-To: <20170314134759.GB14605@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-03-14 14:47, David Sterba wrote:
> On Tue, Mar 07, 2017 at 11:48:37AM +0800, Qu Wenruo wrote:
>> So raid56 bug fixes are the same case as qgroup fixes now?
> 
> Not now, it's been like that forever. Or should have been, we're not
> perfect, but should strive not to skip reviews just because we want to
> let new code in.
> 
>> No reviewer so no merge?
>>
>> I understand we need enough reviewer, however there is never enough 
>> reviewer for *minor* functions, like qgroup or raid56.
> 
> I would not call them minor. Qgroups are hooked to the core of the
> operations, raid56 is a compartment, but can become complex regarding
> the error modes and safety constraints.
> 
>> Such situation will just make such functions starve, bugs makes fewer 
>> tester and users, fewer users leads to even fewer developers, causing a 
>> minus spiral.
> 
> Unreviewed code is more buggy, leads to the same. You've been around for
> a long time, I'm sure you'll remember times when an underreviewed
> patchset caused headaches for several major releases. All developers
> have record of a major problem in their code, that's why we must do the
> reviews.

David, I appreciate your "conservative" approach; but ... how we could exit from this loop ? 

Qu is in the right stating that if there are bugs, nobody uses raid5/6; nobody is interested in the review; and the patches are unaccepted; but doing so the problem will not be not solved.

I am not skilled enough to say if the Qu's patches are completely wrong or these are able to solve the bugs. But which are the other options ?

We are not talking about enhancement, we are talking about bugs in the recovery path of a failing raid5/6 file-system. If we cannot ensure this functionality, raid5/6 is not useful at all.

I think that we should discuss about an exit strategy from this issue. If we aren't able to develop and deploy possible fixes, we should consider deprecating raid5/6 altogether (i.e. prevent btrfs-progs from creating a raid5/6 filesystem, and after some time prevent the kernel to mount this kind of filesystem at all).

I hope that these issues will be addressed and BTRFS will gain a good raid5/6 support. But otherwise I think that it is better to deprecate it than support a badly implementation.


BR
G.Baroncelli


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
