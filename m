From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Snapshot rollback
Date: Tue, 25 Oct 2011 16:01:15 +0700
Message-ID: <CAG1y0sdEdFb_rYXFf7S-+OdTNBeoO1Z_7XC6Qw_JgG+S36baaw@mail.gmail.com>
References: <4EA46E3A.9090307@cfl.rr.com>
	<loom.20111024T071806-3@post.gmane.org>
	<CAG1y0sfmnD8W7an-7HicwfH0HuzJA4wnOLq90qn5iTJmEs4v0w@mail.gmail.com>
	<loom.20111024T101858-236@post.gmane.org>
	<CAG1y0sc_2+NZm0o8Ng_kyjWgZLZZ3SaJ3=5-0SG2_4r1tKjwoQ@mail.gmail.com>
	<loom.20111025T034412-244@post.gmane.org>
	<CAG1y0sfk3TozN0-das7et0StL5pcFFLv4tn3XHKxG56xftuPEA@mail.gmail.com>
	<4EA6794D.3000608@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EA6794D.3000608@parallels.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 25, 2011 at 3:54 PM, dima <dolenin@parallels.com> wrote:
>>> Hi Fajar,
>>> I think I am doing just this, but my subvolumes are not visible und=
er
>>> /boot. I
>>> have all my subvolumes set up like this:
>>> /path/to/subvolid_0/boot< =A0a simple directory bind-mounted to /
>>> /path/to/subvolid_0/__active< =A0my / subvolume
>>> /path/to/subvolid_0/__home< =A0my /home subvolume
>>
>> Actually with that setup you're using option (3) that I described.
>>
>> That means all your subvolumes is still visible under
>> /path/to/subvolid_0/, right? I'm not sure how well grub can manage
>> this. Probably it can't, so you'd have to manage boot entries
>> manually.
>
> Yes, you are right. I can see all subvolumes under /path/to/subvolid_=
0
> By the way grub2 can manage this setup correctly and generate the rig=
ht menu
> entries without any problems.
>
> But - /boot is not in its own subvolume in this setup. I think this i=
s the
> reason it works out of the box.
>
> Thank you for your explanations.
> I can see if I can make it work with /boot in its own subvolume.

If you currently have it working, then as long as you have the full
subvolid=3D0 mounted somewhere and use bind-mount from that, it
shouldn't matter whether it's a subdir or a subvol. But if you mount
the subvol directly in /boot, you'll have the same problem I do.

So it's a trade off, I guess. You can have grub manage grub.cfg
correctly, but you need to have the full tree mounted somewhere. Not
ideal, but a possible option which I hadn't thought of before.

Thanks for sharing your setup.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
