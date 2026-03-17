Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33B538FA3
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 00:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773706174; cv=pass; b=VH4Qu3tu/1RbOgPhvv6S2fpQtiRgBKGAv9k39sxAwDY2NYJeXv8izb6S1VsZzfrNpag+uHtNR3lBwhL0sdCVbihQ9jmM0UXz07WHC1NnmUslSvrsGRuyJjt6yKooj8g7uCoZXd6schJuzO7uE1Euzqv+K39jAG6lcit+H6r5gyw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773706174; c=relaxed/simple;
	bh=hHH0zbsAVNkdVzk96SM2ZhuoyeFWcJYCO04DOXgNmMo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tny2/4+YK3zq062BrTyRIsjbT39toWhqUDKseFIFAwwsdpmy6T8MOJnsDAoYTshTCZHUxOiWBW0W8hA4jgq0qI4SoHJeoIOPrCyyK0Cvs+fF0n8cz1IfAnU/Hp26LHITPHgf3k07NnQVv/vF4qsopISgw1O5wGi8THXTmb9ckZ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lg1wpstQ; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lg1wpstQ"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b9795ca4e6dso442091266b.2
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 17:09:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773706171; cv=none;
        d=google.com; s=arc-20240605;
        b=FEDQQ6HobGZoDir3Vw5OoMzl03a1JGfK0XLY8cI9Ssve37zMOfYPL+NnbR2mBVLqUF
         FcE1fjSuFOMVItJkyBHWkjI5I23GuhgLXRQ36VJCMBS/X0SpV2X7xWk5rQkb/vc+u5mc
         KmO7Ej02KtmXX6Ve9Yjgl5TLJnlZ13iIvLDtUptQIXJTnhYEpzdPahrbhN/ku+N6WPIo
         UQvfYceNgyWSnVP1kSHpIgK0kPDQFgEbWiwZGZa1i67UsVwMEOlJKk5jOI3WSpO1Fbxy
         AwqAXXo0FwSIAJbK6HQfEXOacmPV9OLXNnb6p0MCSSvLeuusOOa5n/XF+ZNh5ZlfDnNg
         JBYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hHH0zbsAVNkdVzk96SM2ZhuoyeFWcJYCO04DOXgNmMo=;
        fh=5XBbIA7wpfMgLi5oasKn5nUtReWeq6WjaROnXA/fauA=;
        b=YqJYy7oU3LlAYSowrT9KfT9sS0Z04hG2qEmc777aUeYxPGCUgas4sAPLhGt6mPM9Pd
         d957TcPIfU1AoAHMQmynzlXxqgpyUv/8BBS49Sqevk4XYh+scM08jGALEyAeaBzcbcqx
         VNeS80fzNVhmHnIDkz7mhLQzj/x5VNprirAAxND3lLOa35sX0NfHLrHzVPyppRZLWJ2i
         QaidoAox8dA07EI6tZ2liOdhI86jlqR9Ej44TBug18q27AbMIYP1WZbKiKG6CsYR2nLs
         m+Crpt5skEFtEniOB3qqqJ9c6OsAqdt4kfMnP0PJqCv6jG65M7gVnxUanLrjqvba3iuz
         tGCg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773706171; x=1774310971; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hHH0zbsAVNkdVzk96SM2ZhuoyeFWcJYCO04DOXgNmMo=;
        b=lg1wpstQw5qLe0+ZJxVtqY1awPE/bYFmqRoPnSQoq1IDdO415Q51LvdA/UBlImgg4U
         kaN4RCn3wz6g01DLUj4ABOPTAWGTpCS/YlsweG7BtweKV2h6N4CH87olHDmTj6SZYjaA
         fUqI9fdde1tMVCFv+RzUyCXD8h2HDhZ7PqcjeIkH9FBjcQyRsFuhjotxTMPzK0VtEV++
         eK6fb4VaWy34NyphWTYsWifHXBQZ2B5CFyi66S7W4V11skIAMU9UDdgIlMdyujIpVut5
         fbiqWJitlA2/z1wF2LaF23fioc9KK4WTinmB4nnQ77kGyFk+L+jyJfaeWTGry2jEFJNR
         o2aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773706171; x=1774310971;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hHH0zbsAVNkdVzk96SM2ZhuoyeFWcJYCO04DOXgNmMo=;
        b=Fd4UHdnVE/6YBaJbUr1AI/ZD6Wke5d4wa34Xgd/tuGobf/QQbCVqQvLZXy25LeXWgl
         hBtcqJDr72MR1LN1g5IhrMHJQdVvYF7CY78OSUsaI5Uo9F4w+6MOzng1BDUqOXbyE38z
         z0hLMIkIPaek4wYgYjGekyQ2AhF+aZkBlrkbT3+ZiBA8SeQ0CWapp7v7S+3PV/ZiOx+p
         2CFw5B2GLZV4BkddYVhWrbG/g4DpWAfA9GPQ0EUKNWimuwz5sfqu1APIsu6bZ/P9RIuU
         6UOObhKoRwbOkUjxTn4gireqZJl3KdG1Wvm3XUORWfgfdjEBSXV9ecK7ApRkgKtlxXH0
         XP1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXu20AwAfbp5z+irmaJyzEUD21q6YpCBlGI+W+XMWLJa9u8NPfYiu/IPMeswZ/nkVuj4fugzCmFdpndeA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1wJbVZaNebvWu0A8wRdvA6jvITJxVUcahIuSOmz6mCD85m13l
	l/SIfscoXnjAcGM5oafZma6RmUwkW6QtxUil3b3wKLzuprBLjsZ6H7D1BmTVLTYuxRG6daRW/qH
	0TI5iyUL9tyqdwSe8L3ZYfTVjP1sLcFs=
X-Gm-Gg: ATEYQzwRU+gfKdlpjnU8DqfVUReVu7QEoUuX8uDDv8n5l51jGQhH5Foi1o78za+oSIg
	7OkPnhcPtPGZfGFm3byOBr3GtH+qPnxJTLekZOjJWQj0t3ccbf0/OuqrucE6/Dp+rlNO6cxy+sA
	jQlbVtira6QHpX888VzBdKzmO1o8BuQlAcPtM5R7uiPQJcLQceZlw8PPwZm/f5a5ZfMWZOqBtAE
	xK590Ji4kWKy8k1xRbJ6y+Tbl0ft1QXBwDJc3q4/Rr5ubDQiKSsM9QaECZs4nB9Weqs/+P5aG+5
	lTwVpji3ZR3I+1pRt5Mu5Bwlge46NNYyKjI0HVyA98NrCyAVfIVKi1SW63sT8FjvfwrpabCgJzX
	HHqqtabnEvoE=
X-Received: by 2002:a17:907:3f9a:b0:b97:dcdd:615 with SMTP id
 a640c23a62f3a-b97dcdd101bmr46515066b.13.1773706170825; Mon, 16 Mar 2026
 17:09:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260316134640.2605237-1-gality369@gmail.com> <f3497ad9-8ee6-4185-b935-013e596e764d@suse.com>
In-Reply-To: <f3497ad9-8ee6-4185-b935-013e596e764d@suse.com>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Tue, 17 Mar 2026 08:09:19 +0800
X-Gm-Features: AaiRm50tF6oYZiQBR8o55N2avJfUEiXBS-geZWxPXng4elSLAAsBYaYsERiaW1c
Message-ID: <CAOmEq9VVwimgxYxhUaRUv+7es4xd6u7-ttYGCeHC-+_Z1V6jhg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: balance: fix null-ptr-deref in btrfs_may_alloc_data_chunk
To: Qu Wenruo <wqu@suse.com>
Cc: dsterba@suse.com, clm@fb.com, bo.li.liu@oracle.com, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 17, 2026 at 4:46=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
> I'd say adding a proper chunk/bg mapping check is the root fix.
>
> Or you'll need to adhoc a lot of null pointer checks.

Thank you for the reminder. A patch addressing the root cause of this
issue has already been submitted, but I am unsure if the solution is
fully appropriate and would appreciate further guidance. The relevant
patch series can be found here:
https://lore.kernel.org/all/20260314123741.1439792-1-gality369@gmail.com/.
Please take a look at the series.

Since you are not directly responsible for this, I didn't CC you on
the email to avoid causing any disruption. Apologies for any
inconvenience this may have caused.

Looking forward to your feedback,
ZhengYuan Huang
