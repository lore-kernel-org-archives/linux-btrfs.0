Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:47210 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759008Ab3BLXH1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 18:07:27 -0500
Message-ID: <511ACB32.3030106@tiscalinet.it>
Date: Wed, 13 Feb 2013 00:07:30 +0100
From: Goffredo Baroncelli <kreijack@tiscalinet.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: dsterba@suse.cz
CC: kreijack@inwind.it, Filipe Brandenburger <filbranden@google.com>,
        Ian Kumlien <pomac@demius.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/6] Btrfs-progs: add btrfsck functionality to btrfs
References: <1360283822-23452-1-git-send-email-pomac@demius.net> <1360283822-23452-3-git-send-email-pomac@demius.net> <20130212163938.GA12339@twin.jikos.cz> <CADU+-uBA3k3wW_tLDR4WvRt1EaitWcUNGXCzs6xhYJ_ExSmXkw@mail.gmail.com> <511A837D.7090203@gmail.com> <20130212225207.GD12339@twin.jikos.cz>
In-Reply-To: <20130212225207.GD12339@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/12/2013 11:52 PM, David Sterba wrote:
> On Tue, Feb 12, 2013 at 07:01:33PM +0100, Goffredo Baroncelli wrote:
>> On 02/12/2013 06:37 PM, Filipe Brandenburger wrote:
>>> Hi,
>>>
>>> On Tue, Feb 12, 2013 at 8:39 AM, David Sterba <dsterba@suse.cz> wrote:
>>>> +# For backward compatibility, 'btrfs' changes behaviour to fsck if it's named 'btrfsck'
>>>> +btrfsck: btrfs
>>>> +       @echo "    [CP]     $@"
>>>> +       $(Q)cp btrfs btrfsck
>>>> +
>>>
>>> I think the idea was that btrfsck becomes a link (either symbolic or
>>> hardlink works) to btrfs...
>>>
>>> Maybe just replace cp with ln?
>>
>> I agree with Filipe, or even a script is reasonable. So we have only one
>> binary to update, and we avoid the risk to have a version mismatch
>> between btrfsck and btrfs. This could lead to a different behaviour
>> when the user call btrfsck instead btrfs. Finally this could save some
>> bytes of space.
> 
> Ok, I'll replace it with a hardlink. A symlink is not reliable (cannot
> be copied without breaking the path).

...mmm... the install command (invoked by the Makefile during the
installation phase) doesn't seem to preserve both the hard-link and the
soft-link:

$ touch test
$ ln test test2
$ ln -sf test lntest
$ mkdir t3
$ install test2 t3/
$ install lntest t3/
$ ls -li lntest test test2 t3/test2 t3/lntest
3005857 lrwxrwxrwx 1 ghigo ghigo 4 Feb 13 00:03 lntest -> test
3005858 -rwxr-xr-x 1 ghigo ghigo 0 Feb 13 00:03 t3/lntest
3005854 -rwxr-xr-x 1 ghigo ghigo 0 Feb 13 00:00 t3/test2
3005852 -rw-r--r-- 2 ghigo ghigo 0 Feb 13 00:00 test
3005852 -rw-r--r-- 2 ghigo ghigo 0 Feb 13 00:00 test2

I think that a bash script is a better choice.

>> Anyway my opinion would be to left this kind to decision to the
>> distribution. We (as upstream) should only remove the old btrfsck and
>> issue an WARNING/REMARK in the release note to notify this change.
>> Unfortunately btrfsck is old; now we must provide an alternative file to
>> overwrite this binary in order to avoid the mismatch above when the user
>> is used to recompile the binary from the source.
> 
> A warning is a good idea and it will start a deprecation period of
> btrfsck as separate utility. Unil some point in future, I'd rather stay
> conservative and let it exist.
> 
> david
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
