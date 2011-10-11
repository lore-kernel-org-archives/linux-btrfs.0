From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH] Btrfs: allow us to overcommit our enospc reservations
 TEST THIS PLEASE!!!
Date: Tue, 11 Oct 2011 15:45:45 -0500
Message-ID: <CAKcLGm-y5on_dWjaNdSARd5_K5nri0G9zuMZAsV19ecuYmXH9g@mail.gmail.com>
References: <1317072155-26792-1-git-send-email-josef@redhat.com>
	<CAKcLGm_oFQOCCeFs69ohGfskkCj1FSbdxL18653ANoTX75n4SQ@mail.gmail.com>
	<20111011190049.GG2293@localhost.localdomain>
	<CAKcLGm-JU1e4ssv9FQTieX-OmHgbc6hef8Rnsy_R7Jy3RwsznA@mail.gmail.com>
	<20111011200131.GH2293@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111011200131.GH2293@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 11, 2011 at 3:01 PM, Josef Bacik <josef@redhat.com> wrote:
> On Tue, Oct 11, 2011 at 02:44:09PM -0500, Mitch Harder wrote:
>> On Tue, Oct 11, 2011 at 2:00 PM, Josef Bacik <josef@redhat.com> wrot=
e:
>> > On Tue, Oct 11, 2011 at 12:33:48PM -0500, Mitch Harder wrote:
>> >> On Mon, Sep 26, 2011 at 4:22 PM, Josef Bacik <josef@redhat.com> w=
rote:
>> >> >
>> >> > go from taking around 45 minutes to 10 seconds on my freshly fo=
rmatted 3 TiB
>> >> > file system. =A0This doesn't seem to break my other enospc test=
s, but could really
>> >> > use some more testing as this is a super scary change. =A0Thank=
s,
>> >> >
>> >>
>> >> I've been testing Josef's git.kernel.org testing tree, and I've
>> >> bisected an error down to this commit.
>> >>
>> >> I'm triggering the error using a removedirs benchmark in filebenc=
h
>> >> with the following profile:
>> >> load removedirs
>> >> set $dir=3D/mnt/benchmark/filebench
>> >> set $ndirs=3D400000
>> >> run
>> >>
>> >
>> > Ok try this one, it will write out more and harder, see if that he=
lps. =A0Thanks,
>> >
>>
>> Still running into BUG at fs/btrfs/inode.c:2176!
>
> How about this one?
>

Sorry, still getting the same bug.

[  175.956273] kernel BUG at fs/btrfs/inode.c:2176!
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
