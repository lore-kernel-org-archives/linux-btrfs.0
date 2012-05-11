From: Christian Brunner <christian@brunner-muc.de>
Subject: Re: Ceph on btrfs 3.4rc
Date: Fri, 11 May 2012 15:46:10 +0200
Message-ID: <CAJafhzSSnEyoMPxkL9Hm+m9PV0Jck_Vq1-sHAsMnyNfz0E71gg@mail.gmail.com>
References: <CAJafhzSVZ3+1ApgJU=sQu6gM62BeWVGG4mqFPNYRHx79czYJtQ@mail.gmail.com>
	<20120424152141.GB3326@localhost.localdomain>
	<Pine.LNX.4.64.1204240922040.29159@cobra.newdream.net>
	<CAJafhzSgaQ3sx=Af0Ru0CiwQH37V5y8jgjoTo_8yozcjo9rpPA@mail.gmail.com>
	<20120510203523.GD2061@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20120510203523.GD2061@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

2012/5/10 Josef Bacik <josef@redhat.com>:
> On Fri, Apr 27, 2012 at 01:02:08PM +0200, Christian Brunner wrote:
>> Am 24. April 2012 18:26 schrieb Sage Weil <sage@newdream.net>:
>> > On Tue, 24 Apr 2012, Josef Bacik wrote:
>> >> On Fri, Apr 20, 2012 at 05:09:34PM +0200, Christian Brunner wrote=
:
>> >> > After running ceph on XFS for some time, I decided to try btrfs=
 again.
>> >> > Performance with the current "for-linux-min" branch and big met=
adata
>> >> > is much better. The only problem (?) I'm still seeing is a warn=
ing
>> >> > that seems to occur from time to time:
>> >
>> > Actually, before you do that... we have a new tool,
>> > test_filestore_workloadgen, that generates a ceph-osd-like workloa=
d on the
>> > local file system. =A0It's a subset of what a full OSD might do, b=
ut if
>> > we're lucky it will be sufficient to reproduce this issue. =A0Some=
thing like
>> >
>> > =A0test_filestore_workloadgen --osd-data /foo --osd-journal /bar
>> >
>> > will hopefully do the trick.
>> >
>> > Christian, maybe you can see if that is able to trigger this warni=
ng?
>> > You'll need to pull it from the current master branch; it wasn't i=
n the
>> > last release.
>>
>> Trying to reproduce with test_filestore_workloadgen didn't work for
>> me. So here are some instructions on how to reproduce with a minimal
>> ceph setup.
>> [...]
>
> Well I feel like an idiot, I finally get it to reproduce, go look at =
where I
> want to put my printks and theres the problem staring me right in the=
 face.
> I've looked seriously at this problem 2 or 3 times and have missed th=
is every
> single freaking time. =A0Here is the patch I'm trying, please try it =
on yours to
> make sure it fixes the problem. =A0It takes like 2 hours for it to re=
produce for
> me so I won't be able to fully test it until tomorrow, but so far it =
hasn't
> broken anything so it should be good. =A0Thanks,

Great! I've put your patch on my testbox and will run a test over the
weekend. I'll report back on monday.

Thanks,
Christian
--
To unsubscribe from this list: send the line "unsubscribe ceph-devel" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
