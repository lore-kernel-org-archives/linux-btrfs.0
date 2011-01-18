From: C Anthony Risinger <anthony@extof.me>
Subject: Re: [GIT PULL] Btrfs updates
Date: Tue, 18 Jan 2011 12:51:23 -0600
Message-ID: <AANLkTimP5oJ6r815jdEn9ALx2zGR=Uy0eSHJ4Oj-AB-M@mail.gmail.com>
References: <1295298216-sup-6206@think>
	<20110118101436.GA2652@scooter>
	<AANLkTimDGtzw9GSC7FigFsKO+w9cO30LUZ2=XK0aK9Hj@mail.gmail.com>
	<AANLkTimcLOFoJ8m2PBG9nsfw4L3FGPNa+RN=Cj_-nZdC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Felix Blanke <felixblanke@gmail.com>, linux-btrfs@vger.kernel.org
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimcLOFoJ8m2PBG9nsfw4L3FGPNa+RN=Cj_-nZdC@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 18, 2011 at 11:56 AM, Mitch Harder
<mitch.harder@sabayonlinux.org> wrote:
> On Tue, Jan 18, 2011 at 9:22 AM, C Anthony Risinger <anthony@extof.me> wrote:
>> On Tue, Jan 18, 2011 at 4:14 AM, Felix Blanke <felixblanke@gmail.com> wrote:
>>> Hi,
>>>
>>> just slap me if the question is stupid, but when will all those new features be added
>>> to the btrfs-progs?
>>>
>>> The last commit is at
>>> "git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git"
>>> is from oct. 2010?!?
>>
>> i don't know about the readonly snapshots, but the LZO stuff is a
>> mount option; should be in the pull.
>
> There was also a patch submitted by Li Zefan for LZO support in btrfs-progs:
>
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg06931.html
>
> If I recall correctly, btrfs-progs will throw out an error once you
> use LZO compression since btrfs-progs needs to be made aware of the
> INCOMPAT flag in the patch submitted above.
>
> My local btrfs-progs git repository also incorporates patches to
> support mixed data+metadata (which also uses an INCOMPAT flag aleady
> in the kernel code) and for the filesystem diskinfo command.
>
> A quick search for "btrfs-progs" in my Mailing List archive turns up a
> number of other btrfs-progs patch proposals since October.

ah, indeed.  should probably include all that before .38 then... and
maybe even cut a .20 btrfs-progs "release" so everyone is on the same
page :-) there have been several questions regarding that alone.

C Anthony
