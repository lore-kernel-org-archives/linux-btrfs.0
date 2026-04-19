Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C4937B41F
	for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2026 13:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776604458; cv=pass; b=VKrJT6H289WL3b804QHzpJjn9uYO2yuN8btanTmSJgeLm6MryO2gi2jvze6zt/hT1vUDDSg4YhEJBJbhBWIFGAMB3y6mq7/LLj5En1iplm1Uq/54DvqCh0ZX4nYGIABRR/JgHY4MqJZNDFy/xTlrlnwySapHfwO0IFV6Ythn3v8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776604458; c=relaxed/simple;
	bh=qe/8/rd6eZq24hJL9eY4fBiSEHVVKDLumzkH60jo5p0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jEbnNLW3XV+buhf7uxXRXkMfEmrtxOmPrD5Zm8M7pzveYAmQJRd/PItEr/ABi6JQdJdWC57uMsTdIKT4LoyqkbcVTPouxxlCkMJFreKHJFcQ6QuCjv6QwKGFOEvp+rFZ+2s1j3bl4mlmy5zve3TQq+7pvAQ9v6oH4vdNTguiPIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=RF+j7+hH; arc=pass smtp.client-ip=74.125.224.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="RF+j7+hH"
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-651c7ddf514so1997857d50.1
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2026 06:14:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776604455; cv=none;
        d=google.com; s=arc-20240605;
        b=C+cKGQMehCo/iAQ1VnYd0snVjfy6uAxB6H6EOIJe9O8unmKd1V3z9FWC4S8RHlu5U+
         JD/JqVJlBrAp3+wOaUFe2nCCICkuy0H7kjpCvOUwnHWuMbhwL8XiEGpcvb/NDpMX5eSn
         gD886o/QSTxKZj5kYUoP4h8AjglY+EUeQFyuUwFwD6SEpShYKJBfgQMRkPt6v9BPe42d
         rbaQUg1i7Q7x76BF8mTGkcTzqMk/JppAAZPKmMUOR0LCkXqFxVeWh2yiArgVlfLtwOvY
         IELIiazM8amfvmgEpQV5qFkRTrSzOhp1d+LjAmbrDMq18J1cINUDPQpss6+lu26D1zHZ
         0Hrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X+WVMuAIY6fuTgPsvbyDiChtmsWhcTJteNRfYOEl4tw=;
        fh=ppblR1bzmHU030KNFkontHxfhlRadbH7EkdwbjKLCek=;
        b=YGMWN7rfX3U50i6/7cd1BBGE4y6Ia6ich1gTeGVEfgWhKaxydnffk8VyBt2a17dVzb
         EqxNDjOpzacpLfmrM0iNmIvco+Bhpemt+e1+GUq1YWERnGB94PLlE5j5i5R3qPsKCDvM
         acmEGVHLGYMmJYFp04qGy5KXXsujo/BnYTRKymMLn7czJzWoue4TROFHFRYHP8bKKD7X
         A0R2fJaZFTHpW912k90e6GRykG3SMyuXAzYQ/QUjNzsXFWqodVK2ldFYzHgOjC7BiiTF
         EIOrM1w2y41UVMCTf7MaKa870qjDZYeeo2pMkD0rJHjf/cmSGeef2MSXGCbm+8Tb+F5R
         twcg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1776604455; x=1777209255; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X+WVMuAIY6fuTgPsvbyDiChtmsWhcTJteNRfYOEl4tw=;
        b=RF+j7+hHVxK6KZm7vPd2VqoOm/wjdXQLWhOzfortaWaPcUVwcAQrCs3L0CFMuiRg7q
         QnfAqyyLg1KJ+FRhOaVPXbDj/1oQAlKqMc8aZVWWLmxNSIvN0DqnMlIAoJn6kuX0b/7J
         7sPHT3tJByJtn837fhiWKur8kP67w4ITGeKuH61ShAM9KSbiPZhuqcwRf0AI+YYvfUzE
         nm7TFbEi+qyg5VUzXDZfGrK2suVGd+PyZxZUbRBAHRptfz+N0eKCGeaG7itaOxMnDo4a
         9pQYTEUA6X1M/ONh/tBNfIzrR7/o898AAKuwOGzc6VJY9VVEJ/2rd2ZdsoDfuP51zO2Z
         aU3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776604455; x=1777209255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X+WVMuAIY6fuTgPsvbyDiChtmsWhcTJteNRfYOEl4tw=;
        b=HwgsGr+yufURB4hocS9Fuuik7WEnrchDua6U8+D8iTQF3rKxaLgOw4G5FO6W7F/F0e
         OdNsAZZ8+KY5kawOBnS+nrO/PoItGw66ORpE/YCTmjrd5lF+fqmg5nYsMC8qqqs+wBcV
         0Kzlybq9Y00L0OidYpuBH8HNCta4aJ3wtIXD+0sKHPa7k3wE/DxaO1TqoJeQei+FPUB8
         CVPRxg56Is6Fbi0RVq/uFP3eTVQCOxIEkRKkDfWYg5icZcj7mP2Abu7aTC0bfv3Hep+m
         jMDSpC9wkZho+fJROGj+AuVPg5AxvHey3lfISrYFw2i7X9pB9It+nOuCrjIILiDn3wMi
         ycpQ==
X-Forwarded-Encrypted: i=1; AFNElJ/oqbrZPQqW35z3V6xj6+w6ulHKOSQ0fnpUApqKaDOR+cHhcQ+XCXYho/4oAp2r79HsgoUX7NeIQOCz5A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzOLOFAyFNtbrSGxlH74v0Gk6paLtm+BOn37DeCE0GaqExrd+IE
	67XoBYPcuV+T72gB1yaI0PXp7+N3O5uZC8imXwj64lqgxK7IIDCeLCwgtEf8EHlME8rZn1ytpvz
	va5GLzEUHhreZJdSVXJAueIAqDHOvQOIdCJXipmI4xg==
X-Gm-Gg: AeBDietPpwx/npmtUyI3X6g22zyiqJ2yfDyLJ58QqpMWfz5ScPzaNsA3sxTOQBOaLZB
	WXs1zx2OHKr7thvpTgf32h6E5dgusMg+4X7uLfkoqb/XN41nzO2hpprhIVsnrY8901MKfV64k6q
	bjjb51/ir1/IgbQL908mKpPJb5MSwbR5jicoqCJEiUJpxlBwwRZMjcOW5SAdLKiS8d+AZGAkStJ
	S4rkpFlf5QQ57DDpOvCISRLU8y1ob4fXMjPLg8awOUYYuO9IgigmPBwxYBvBKAmZuaBpKbuFfHi
	ckp94OegY/JtQx7HIhVdfXdx1OAf
X-Received: by 2002:a05:690e:4811:b0:651:bcc9:50cd with SMTP id
 956f58d0204a3-653107ccddamr6102177d50.5.1776604455299; Sun, 19 Apr 2026
 06:14:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260323160052.17528-1-vineeth@bitbyteword.org> <20260418190456.631df6f3@fedora>
In-Reply-To: <20260418190456.631df6f3@fedora>
From: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Date: Sun, 19 Apr 2026 09:14:04 -0400
X-Gm-Features: AQROBzCejbUFLEO14GEr24qqxXnlBQ97NPzS668jjkdcYvI-3kvv1xuemSCQk44
Message-ID: <CAO7JXPh+__EWsW8fsKi4T+w0jdPxZEfCLQno_ukJk2=d2s0WKA@mail.gmail.com>
Subject: Re: [PATCH v2 00/19] tracepoint: Avoid double static_branch
 evaluation at guarded call sites
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Dmitry Ilvokhin <d@ilvokhin.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Xin Long <lucien.xin@gmail.com>, Jon Maloy <jmaloy@redhat.com>, 
	Aaron Conole <aconole@redhat.com>, Eelco Chaudron <echaudro@redhat.com>, 
	Ilya Maximets <i.maximets@ovn.org>, netdev@vger.kernel.org, bpf@vger.kernel.org, 
	linux-sctp@vger.kernel.org, tipc-discussion@lists.sourceforge.net, 
	dev@openvswitch.org, Jiri Pirko <jiri@resnulli.us>, Oded Gabbay <ogabbay@kernel.org>, 
	Koby Elbaz <koby.elbaz@intel.com>, dri-devel@lists.freedesktop.org, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>, 
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>, Huang Rui <ray.huang@amd.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, Len Brown <lenb@kernel.org>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, linux-pm@vger.kernel.org, 
	MyungJoo Ham <myungjoo.ham@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>, 
	Chanwoo Choi <cw00.choi@samsung.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, linaro-mm-sig@lists.linaro.org, 
	Eddie James <eajames@linux.ibm.com>, Andrew Jeffery <andrew@codeconstruct.com.au>, 
	Joel Stanley <joel@jms.id.au>, linux-fsi@lists.ozlabs.org, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alex Deucher <alexander.deucher@amd.com>, Danilo Krummrich <dakr@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Philipp Stanner <phasta@kernel.org>, 
	Harry Wentland <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>, 
	amd-gfx@lists.freedesktop.org, Jiri Kosina <jikos@kernel.org>, 
	Benjamin Tissoires <bentiss@kernel.org>, linux-input@vger.kernel.org, 
	Wolfram Sang <wsa+renesas@sang-engineering.com>, linux-i2c@vger.kernel.org, 
	Mark Brown <broonie@kernel.org>, Michael Hennerich <michael.hennerich@analog.com>, 
	=?UTF-8?B?TnVubyBTw6E=?= <nuno.sa@analog.com>, linux-spi@vger.kernel.org, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, 
	Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, 
	SeongJae Park <sj@kernel.org>, linux-mm@kvack.org, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 18, 2026 at 7:05=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Mon, 23 Mar 2026 12:00:19 -0400
> "Vineeth Pillai (Google)" <vineeth@bitbyteword.org> wrote:
>
> >   if (trace_foo_enabled() && cond)
> >       trace_call__foo(args);   /* calls __do_trace_foo() directly */
>
> Hi Vineeth,
>
> Could you rebase this series on top of 7.1-rc1 when it comes out?
> Several of these patches were accepted already. Obviously drop those.
> They were the patches that added the feature, and any where the
> maintainer acked the patch.
>
> Now that the feature has been accepted, if you post the patch series
> again after 7.1-rc1 with all the patches that haven't been accepted
> yet, then the maintainers can simply take them directly. As the feature
> is now accepted, there's no dependency on it, and they don't need to go
> through the tracing tree.
>
Sure, will do. Thanks for merging this feature.

Thanks,
Vineeth
