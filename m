From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: TRIM support
Date: Mon, 11 Jul 2011 14:19:36 +0700
Message-ID: <CAG1y0sdSOj8m8VoqgqO=m0-+iBE_sz-C8iXj-jYVBagKTPGymQ@mail.gmail.com>
References: <CAAeznTr5FMOqyJA9JfP2H-h1rJjasfxUJAeNNnNKhiHCTV03mA@mail.gmail.com>
	<1309635918.3774.7.camel@nayuki>
	<201107101833.31450.chris@csamuel.org>
	<CAAeznTrXzt+jYByWz3fkSH41qStNfWupWNk8SZt75ousuJ3iYg@mail.gmail.com>
	<CAG1y0seg-TTgbdr5_xTjaA_rYoW44AF_pPAFC5_nCNG1qEmNHg@mail.gmail.com>
	<CAAeznTp-XB2eGarkfyVRASyLTULYLz0myPE+GN6TggrxPjv_YA@mail.gmail.com>
	<CAG1y0sf=8PdiXwavma7Vc40td_mpEt+uZJBto+OLW_B+M8QVEQ@mail.gmail.com>
	<CAAeznTrou2TOTGtvKDBudQqaTmHjzNoV8AUug3Uw2uUMJJjJVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAeznTrou2TOTGtvKDBudQqaTmHjzNoV8AUug3Uw2uUMJJjJVg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 11, 2011 at 2:02 PM, Leonidas Spyropoulos
<artafinde@gmail.com> wrote:
> On Mon, Jul 11, 2011 at 7:04 AM, Fajar A. Nugraha <list@fajar.net> wrote:
>> On Mon, Jul 11, 2011 at 5:34 AM, Leonidas Spyropoulos
>> <artafinde@gmail.com> wrote:
>>> So any clues for the intel 320 series? I think it doesn't use compression.
>>
>> At this point your best bet is to try it yourself and see. If it
>> doesn't result in poor performance, then keep on using "-o discard".

> Could you propose me any tools available for measuring performance?
>
> I only know iozone and tunefs -t parameter.

Anything that can measure random write IO is fine. I use fio with this jobfile:

$ cat randomwrite.fio
[write-test]
rw=randwrite
ioengine=libaio
blocksize=4k
iodepth=32
size=1G

the result:
  write: io=1024MB, bw=32395KB/s, iops=8098, runt= 32368msec

If you still have similar performance with and without "-o discard",
then you should add it your mount options.

-- 
Fajar
