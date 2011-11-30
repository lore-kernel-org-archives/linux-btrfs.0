From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: btrfs/git question.
Date: Wed, 30 Nov 2011 13:20:01 +0700
Message-ID: <CAG1y0sc1JE4tAOooPw+6n5KDj9YBxg9iMED5O+RpG3Hgb9m5FQ@mail.gmail.com>
References: <af6c5f5cb5a1778a8d811e8293dfdd73@www.jots.org>
	<4ED43C30.50502@cfl.rr.com>
	<CAG1y0scuoKwH_MbQPGQKr5sYAXP_kB=j6FOMHgm2=EzPwAVL=Q@mail.gmail.com>
	<20111129152206.GL24338@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	"Ken D'Ambrosio" <ken@jots.org>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111129152206.GL24338@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 29, 2011 at 10:22 PM, Chris Mason <chris.mason@oracle.com> =
wrote:
> On Tue, Nov 29, 2011 at 09:33:37AM +0700, Fajar A. Nugraha wrote:
>> On Tue, Nov 29, 2011 at 8:58 AM, Phillip Susi <psusi@cfl.rr.com> wro=
te:
>> > On 11/28/2011 12:53 PM, Ken D'Ambrosio wrote:
>> >> Seems I've picked up a wireless regression, and randomly drop my =
WiFi
>> >> connection with more recent kernels. =A0While I'd love to try to =
track down the
>> >> issue, the sporadic nature makes it difficult. =A0But I don't wan=
t to revert to a
>> >> flat-out old kernel because of all the btrfs modifications. =A0Is=
 it possible
>> >> using git to add *just* btrfs patches to an older kernel?
>> >
>> > Sure: use git rebase to apply the patches to the older kernel.
>>
>> ... or use 3.1.2, and get ONLY fs/btrfs from Chris' for-linus tree,
>> compile it out-of-tree, and use it to replace the original btrfs.ko.
>
> If you're on a 3.1 kernel, you can pull my for-linus directly on top =
of
> it with git pull. =A0I always keep a btrfs tree against the previous
> kernel so that people can use the latest btrfs goodness without havin=
g
> to use an rc kernel.

Yes, thanks for that.

My suggestion is simply an alternative (instead of git pull) for people=
 who:
- aren't quite familiar with git, but know enough to grab a directory
snapshot from gitweb (e.g.
http://git.kernel.org/?p=3Dlinux/kernel/git/mason/linux-btrfs.git;a=3Dt=
ree;f=3Dfs/btrfs;h=3D5f51bd7e3b8b6c4825681408450e6580bdbccce1;hb=3Drefs=
/heads/for-linus)
- know how to build a module out-of-tree
- on the latest stable, but don't want to re-compile the whole kernel
just to get btrfs fix

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
