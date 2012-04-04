From: Arnd Hannemann <arnd@arndnet.de>
Subject: Re: hard links
Date: Wed, 04 Apr 2012 22:12:46 +0200
Message-ID: <4F7CAB3E.1050800@arndnet.de>
References: <4F7C78FE.2020508@arndnet.de> <4F7CA218.5070902@gmail.com> <4F7CA37B.50006@arndnet.de> <20120404195339.GE32070@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
To: Hugo Mills <hugo@carfax.org.uk>, nspmangalore@gmail.com,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120404195339.GE32070@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Hugo,

Am 04.04.2012 21:53, schrieb Hugo Mills:
> On Wed, Apr 04, 2012 at 09:39:39PM +0200, Arnd Hannemann wrote:
>> Am 04.04.2012 21:33, schrieb Shyam Prasad N:
>>> On 04/04/2012 10:08 PM, Arnd Hannemann wrote:
>>>> Hi,
>>>>
>>>> today I experimented with hard links on btrfs and by this used all available inode space of a file.
>>>> Interestingly if this happens even a rename of such an filename to  an _equal length_ filename
>>>> fails:
>>>>
>>>> arnd@kallisto:/mnt/btrfs/tmp$ mv a b
>>>> mv: cannot move `a' to `b': Too many links
>>>>
>>>> Is this expected behavior?
>>>> There should be no reason to let this particular case fail?
>>>>
>>
>>> What do you mean by 'used all available inode space'? What did you do exactly?
>>
> 
>    There's no inode limit specifically. The limit is on the number of
> hardlinks to the same file stored in the same directory (and it's very
> small). This is a known limitation of btrfs. Someone's working on a
> fix (can't remember who, off-hand), but it's not been published yet.

Sorry maybe I was unclear. I didn't want to say I used up all inodes.
I wanted to express that I filled up the space of a particular inode.
My understanding is that the limit on the number of hardlinks to the same
file stored in the same directory, is, because the names of the
hardlinks are stored within the same inode. As such the number of hardlinks is
naturally limited by the size of the inode (and dependent on the length
of the filenames). Correct?

It's not a big deal, but with my original posting I just tried to point
out that btrfs fails an operation while the above constraint is not violated.
The size needed to store the filename "a" is exactly the same as the size needed
to store the filename "b".
Therefore, I would assume the operation mv "a" "b" to just work.

I hope I did clarify my point?

Best regards
Arnd
