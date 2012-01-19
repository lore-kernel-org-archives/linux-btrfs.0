From: Chris Baines <cbaines8@gmail.com>
Subject: Re: bad tree block problems
Date: Thu, 19 Jan 2012 03:26:02 +0000
Message-ID: <CAGGGvRs-Xn4DLeAKROSB25OkVHsb+Y7cN8KPwOviMCJyri=Kuw@mail.gmail.com>
References: <CAGGGvRtNCvt9LYvZE1ZEE9tYCS95KLTUdKKXnqDzm8vHbO-vfg@mail.gmail.com>
 <20111220233637.GP19266@shiny> <CAGGGvRucivqjTz4X7LNdTo_Nx_oXY9wOor4f7zbnbCf_+-XKPw@mail.gmail.com>
 <4EF13156.302@cn.fujitsu.com> <CAGGGvRsse8YhCxeyi+KOWNr2Oav+YS2iR9_4Px3gH4J1=8NH6w@mail.gmail.com>
 <CAGGGvRvVUDbsZKOgqkA+CYfsfpYdHEDF5BYLs3sKVWw+ekH4nQ@mail.gmail.com>
 <CAGGGvRtNS1_aAWh0=NOD9KTjBNY4Z9wDMATGYTOFCN-HXt4ssg@mail.gmail.com> <CAE5mzvgaoWWLoi2ejsFNzZ65h6Hov5KTDtBAAZU+x+4uHONGLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAE5mzvgaoWWLoi2ejsFNzZ65h6Hov5KTDtBAAZU+x+4uHONGLg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Right, I can mount read only. Running a find command across the
filesystem, yields lots of:
[ 7775.228342] btrfs: corrupt leaf, bad key order:
block=3D756502351872,root=3D1, slot=3D1
type messages in dmesg, running a scrub gives:
scrub status for 7d65d152-1200-4043-981a-06757707f1ba
	scrub started at Wed Jan 18 22:29:30 2012 and was aborted after 5575 s=
econds
	total bytes scrubbed: 1.26TB with 0 errors
And in dmesg:
[13370.886533] btrfs bad tree block start 714438135808 714427781120
[13370.962864] btrfs bad tree block start 714438135808 714427781120
[13371.681333] btrfs bad tree block start 714438135808 714427781120
[13371.724529] btrfs bad tree block start 714438135808 714427781120
[13371.724690] btrfs bad tree block start 714438135808 714427781120
[13371.724969] btrfs bad tree block start 714438135808 714427781120
[13371.725099] btrfs bad tree block start 714438135808 714427781120
[13371.725243] btrfs bad tree block start 714438135808 714427781120
[13371.725412] btrfs bad tree block start 714438135808 714427781120
[13371.725714] btrfs bad tree block start 714438135808 714427781120

On 18 January 2012 20:48, cwillu <cwillu@cwillu.com> wrote:
> First thing I'd try is to try mounting it readonly ("mount ... -o
> ro"). =A0This should get it mounted, or at least failing at a later
> point with different (better?) error messages to work from. =A0(dmesg
> output after such an attempt would be useful).
>
> On the vanilla kernel front, Ubuntu has kernel debs without any extra
> patches, which will/should work with debian. =A0(There may be a simil=
ar
> pure debian thing somewhere already, but anyways).
>
> If you see anything about dkms building modules when installing,
> you'll have to disable those in order to prevent the nvidia and
> virtualbox modules from being built/installed with vanilla kernel.
>
> Debs available from
> http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.2.1-precise/
>
> And the relevant dkms lines if applicable (module names may also vary=
,
> but dkms status will list the relevant ones assuming dkms is in fact
> in use):
>
> "dkms status"
> "dkms uninstall -m nvidia -v <from status> -k <from status, something
> something 3.2.1>"
> "dkms uninstall -m vboxhost -v <from status> -k <from status,
> something something 3.2.1>"
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
